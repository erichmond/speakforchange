class Message < ActiveRecord::Base
	has_many :deliveries, :dependent => :destroy
	has_many :plays # to track play count for the message
	
  serialize :messageable_ids


  # meant to be called by the telephony app to prepare the message for access by the rails app
	def package_and_deliver()
		self.geocode
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

	def txt_filename
    self.audio_path + '.txt'
  end
  
  def mp3_filename
    self.audio_path + '.mp3'
  end
  
  def wav_filename
    self.audio_path + '.wav'
  end
  
=begin
	def convert_to_mp3
		wav_full_path = File.join(RAILS_ROOT, "public", self.wav_filename)
		mp3_full_path = File.join(RAILS_ROOT, "public", self.mp3_filename)
		%x[echo "#{Time.now} Going To Run -- /usr/local/bin/lame -cbr -b 32 --resample 22050 #{wav_full_path} #{mp3_full_path}" >> /tmp/agi_hangup.log]
		%x[echo "ls -l #{wav_full_path}" >> /tmp/agi_hangup.log]
		%x[echo "ls -l #{mp3_full_path}" >> /tmp/agi_hangup.log]
		%x[/usr/bin/whoami >> /tmp/agi_hangup.log]
		%x[touch /tmp/bilbo_baggins.txt]
    result = %x[/usr/local/bin/lame -cbr -b 32 --resample 22050 #{wav_full_path} #{mp3_full_path}]
    #    result = %x[/usr/local/bin/lame -cbr -b 32 --resample 22050 #{wav_full_path} #{mp3_full_path}]
		%x[echo "#{Time.now} Conversion to MP3 Result [#{result}]" >> /tmp/agi_hangup.log]
		return
  end
=end
	def audio_path
    "/messages/#{file}"
  end

  def mp3_audio_path
    "/messages/#{file}.mp3"
  end

	def fill_sphinx_fields
    return unless self.deliveries

    if self.is_a?(MessageToLegislator) 
      self.legislator_name = self.legislator_names
    else
      self.issue_name = self.issue.title
    end
  end

	def issue
    messageables.detect {|m| m.is_a?(Issue)}
  end

	def messageables
    deliveries.map {|y| y.messageable}
  end

  def legislators
    # Sen before Rep, then by lastname
    messageables.select {|m| m.is_a?(Legislator)}.sort_by {|x| "#{x.title} #{x.lastname}" }
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

	def deliver
		# check if a delivery has all ready been done
    return if  Delivery.find_by_message_id(self.id)
		# check if we have no messageabl ids for a delivery
  	logger.error "DELIVER for message(#{self.id} failed. messageable_ids is nil)" and return if self.messageable_ids.nil?
		
		# if we have a valid set of ids then proceed
    messageable_ids.each do |msg_id|
			# check if we have a valid messageable_type, if not then do not create a delivery

      messageable = if self.class == MessageToLegislator 
                      Legislator.find(msg_id)
                    else
                      Issue.find(msg_id)
                    end
			self.deliveries.create(:messageable => messageable)
    end

  end
	

end
