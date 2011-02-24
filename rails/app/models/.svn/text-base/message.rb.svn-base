class Message < ActiveRecord::Base
  has_many :deliveries, :dependent => :destroy
  serialize :messageable_ids

  belongs_to :state_object, :foreign_key => "state", :class_name => "State"

  # validates_uniqueness_of :password # commented out because we need to create the message in adhearsion before we generate a password

  validates_length_of :title, :in => 5..80, :allow_blank => true 


  before_create :generate_password

  acts_as_taggable 
  attr_protected :password
  has_many :plays # to track play count for the message

  #before_create :geocode # it might be a better idea to call this manually

  #named_scope :complete, :include => :deliveries, :conditions => ["count(deliveries.*) > 0"]

  named_scope :recent, lambda {|limit|
    limit ||= 10
    {
      :order => "messages.created_at desc", :limit => limit,
      :include => :state_object
    }
  }


  def self.per_page
    20
  end

  define_index do
    
    #fields
    indexes zipcode, :sortable => :true
    #indexes tag_list, :sortable => :true
    indexes state
    indexes title, :sortable => :true

    indexes taggings.tag.name, :as => :tag
    indexes legislator_name
    indexes issue_name
    
    #attributes
    has created_at
    has lat
    has lng
  end

  # Called when a delivery is attached to the message

  def fill_sphinx_fields
    return unless self.deliveries

    if self.is_a?(MessageToLegislator) 
      self.legislator_name = self.legislator_names.join(', ')
    elsif self.issue
      self.issue_name = [self.issue.title, self.issue.description].join(', ') 
    end
  end

	# meant to be called by the telephony app to prepare the message for access by the rails app
	def package_and_deliver()
		self.geocode	
		self.convert_to_mp3
		self.save
		self.deliver
	end

  def geocode
    # check if the lat lng of the zipcode is already geocoded
    if (geolocation = ZipcodeGeolocation.find_by_zipcode(zipcode))
      self.lat, self.lng = geolocation.lat, geolocation.lng
    else
      geo = GeoKit::Geocoders::MultiGeocoder.geocode(zipcode)
      if geo.success
        self.lat, self.lng = geo.lat, geo.lng
        # cache zipcode geolocation
        ZipcodeGeolocation.create :zipcode => zipcode,
          :lat => self.lat, 
          :lng => self.lng
      else
        errors.add(:address, "Cound not geocode address")
      end
    end
  end

  def self.state_from_zip(zipcode)
    # check if the lat lng of the zipcode is already geocoded
    if zipcode.length != 5
      return nil
    end
    if (geolocation = ZipcodeGeolocation.find_by_zipcode(zipcode))
      Message.reverse_geocode_state(geolocation.lat, geolocation.lng)
    else
      geo = GeoKit::Geocoders::MultiGeocoder.geocode(zipcode)
      if geo.success
        
        state = Message.reverse_geocode_state(geo.lat, geo.lng)

        # cache zipcode geolocation
        ZipcodeGeolocation.create :zipcode => zipcode,
          :lat => geo.lat, 
          :lng => geo.lng
        return state
      else
        return nil
      end
    end
  end

  def self.reverse_geocode_state(lat, lng)
    res = Geokit::Geocoders::GoogleGeocoder.reverse_geocode("#{lat},#{lng}")
    res.state
  end

  def audio_path
    "/messages/#{file}"
  end

  def mp3_audio_path
    return nil unless file
    if !self.converted
      logger.info "CONVERTING Message #{id} to MP3 [hangup]"
      self.convert_to_mp3
    end
    "/messages/#{file}.mp3"
  end

  def generate_password
    pass = (1..5).map { (rand(10) + 1).to_s }.join
    if Message.find(:first, :conditions => {:password => pass, :zipcode => self.zipcode}) 
      generate_password
    end
    self.password = pass
  end

  def deliver
		# check if a delivery has all ready been done
    return if  Delivery.find_by_message_id(self.id)
		# check if we have no messageabl ids for a delivery
  	logger.error "DELIVER for message(#{self.id} failed. messageable_ids is nil)" and return if self.messageable_ids.nil?
		
		# if we have a valid set of ids then proceed
    messageable_ids.each do |msg_id|
			#msg_type = self.messageable_type
			# check if we have a valid messageable_type, if not then do not create a delivery
			#logger.error "ERROR! messageable_type is nil, so delivery not possible" and next if msg_type.nil?
      messageable = if self.class == MessageToLegislator 
                      Legislator.find(msg_id)
                    else
                      Issue.find(msg_id)
                    end
			self.deliveries.create(:messageable => messageable)
    end
  end

  def legislator_names(version = :short)
    return unless self.is_a?(MessageToLegislator)
    case version
    when :micro
      deliveries.map {|d| d.messageable.lastname} 
    else :short
      deliveries.map {|d| d.messageable.shortname} 
    end
  end

  def messageables
    deliveries.map {|y| y.messageable}
  end

  def legislators
    # Sen before Rep, then by lastname
    messageables.select {|m| m.is_a?(Legislator)}.sort_by {|x| "#{x.title} #{x.lastname}" }
  end

  def issue
    messageables.detect {|m| m.is_a?(Issue)}
  end

  def title_for_rss
    x = if self.is_a?(MessageToLegislator)
     "Message from #{state} #{zipcode} to #{legislator_names.to_sentence}"
    elsif self.issue
     "Message from #{state} #{zipcode} on #{self.issue.title}"
    else
     "Message from #{state} #{zipcode}"
    end
    x
  end

  def description_for_rss
    x = ''
    if self.title
      x += "Title: #{title}\n\n"
    end
    if !self.tag_list.blank?
      x += "Tags: #{self.tag_list}\n\n"
    end
    x

  end

  def mp3_exists?
    File.exists?(mp3_filename) #self.storing_path + '.mp3')
  end

  def store_duration
    begin
      %x[sox #{RAILS_ROOT}/public#{self.wav_filename} -n stat &> #{RAILS_ROOT}/public#{self.txt_filename}]
      myarray = Array.new

      File.open("#{RAILS_ROOT}/public#{self.txt_filename}") do |txt|
        txt.each do |line|  
          unless line.chomp.length == 0
            key, value = line.split(':')
            myarray.push key.strip, value.strip
          end
        end
      end
      duration = myarray[3].to_f.round
      self.duration = duration
      self.save
    rescue
      # something went wrong, just make the duration 0 and keep it moving.
      self.duration = 0
      self.save
    end
  end

  def convert_to_mp3
		wav_full_path = File.join(RAILS_ROOT, "public", self.wav_filename)
		mp3_full_path = File.join(RAILS_ROOT, "public", self.mp3_filename)
    %x{lame -cbr -b 32 --resample 22050 #{wav_full_path} #{mp3_full_path}}
    if File.exist?(mp3_full_path)
      self.update_attribute :converted, true
    end
  end

  def self.process_unconverted
    Message.unconverted.each do |x|
      logger.info "converting audio for message #{x.id} [hangup case]" 
      x.convert_to_mp3
    end
  end
  
  def txt_filename
    self.audio_path + '.txt'
  end
  
  def mp3_filename
    self.audio_path + '.mp3'
  end
  
  def wav_filename
    self.audio_path + '.wav'
  end

  named_scope :converted, :conditions => {:converted => true}
  named_scope :unconverted, :conditions => ["converted = 0 and file is not null"]

  # We're just using this to insert a cute image for issue messages, for now.
  # Later we can use subject-specific images from flickr or something.
  PAST_PRESIDENTS = %W{ washington.jpg adams.jpg fdr.jpg ike.jpg  jackson.jpg
  jefferson.jpg jqadams.jpg kennedy.jpg lincoln.jpg tr.jpg truman.jpg wilson.jpg }

  def filler_image
    PAST_PRESIDENTS[self.id % PAST_PRESIDENTS.length]

  end

end
