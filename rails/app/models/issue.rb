class Issue < ActiveRecord::Base
  validates_uniqueness_of :title
  has_many :deliveries, :as => :messageable, :order => "deliveries.created_at desc"
  has_many :messages, :through => :deliveries, :order => "messages.id desc"
  attr_readonly :deliveries_count

  before_create :assign_extension, :create_alphabetical_title

  def image(version = :small)
    "capitol2.jpg"
  end
 
  def assign_extension
    # TODO change this later so if we delete issues, we can reuse their extensions
    self.extension = (Issue.count + 1001).to_s
  end

  def create_alphabetical_title
    self.alphabetical_title = self.title.downcase.gsub(/^(a|an|the)\s+/, '')
  end

  def title=(x)
    x =  x.split(" ").map {|w| w.capitalize}.join(' ')
    write_attribute(:title, x)
  end

  define_index do
    
    #fields 
    indexes title
    indexes description
    
    # attributes
    has created_at
    
  end

end
