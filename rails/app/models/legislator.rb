class Legislator < ActiveRecord::Base
  #validates_uniqueness_of :votesmart_id
  has_many :deliveries, :as => :messageable, :dependent => :destroy, :order => "deliveries.id desc"
  has_many :messages, :through => :deliveries
  attr_readonly :deliveries_count

  before_create :assign_extension

  def assign_extension
    # TODO change this later so if we delete legislators, we can reuse their extensions
    self.extension = ((max = Legislator.max_extension) ? max + 1 : 101).to_s
  end

  def self.max_extension
    xs = Legislator.all(:select => "extension").map {|x| x.extension.to_i}
    xs.max
  end


  def image(version = :small)
    if bioguide_id && image_file 
      version == :small ?  "40x50/#{bioguide_id}.jpg" : "100x125/#{bioguide_id}.jpg"
    else
      "40x50/nophoto.jpg"
    end
  end
  
  def fullname
    [title + '.', firstname, lastname + (name_suffix ? ', ' + name_suffix : ''), "(#{party})", state].join(' ')
  end

  def shortname
    [title + '.', firstname, lastname + (name_suffix ? ', ' + name_suffix : '')].join(' ')
  end

  def lastname_first_no_title
    [lastname + ",", firstname +  (name_suffix ? ', ' + name_suffix : '')].join(' ')
  end


  define_index do
    
    #fields
    indexes [firstname, middlename, lastname, nickname], :as => :name, :sortable => :true
    indexes website
    indexes email
    indexes phone
    indexes fax
    indexes congress_office
    indexes twitter_id, :sortable => :true
    indexes congresspedia_url, :sortable => :true
    indexes youtube_url, :sortable => :true
    indexes official_rss, :sortable => :true    
    
    #attributes
    has created_at, in_office
  end

  def check_for_image_file
    path = RAILS_ROOT + '/public/images/' + self.image
    if image_file && !File.exist?(path)
      logger.debug("Legislator #{self.id} #{self.lastname} has no picture")
      self.image_file = nil
      self.save
    end
  end
end

