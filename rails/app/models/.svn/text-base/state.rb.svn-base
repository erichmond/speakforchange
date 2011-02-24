class State < ActiveRecord::Base

  set_primary_key "abbreviation"

  has_many :messages, :foreign_key => "state"

  def geocode
    return if lat || lng

    geo = GeoKit::Geocoders::MultiGeocoder.geocode(self.name)
    if geo.success
      self.lat, self.lng = geo.lat, geo.lng
      save
    else
      errors.add(:address, "Cound not geocode state")
    end

  end



  def name
    x = read_attribute('name')
    if x 
      x.split(" ").map {|w| w.capitalize}.join(' ')
    end
  end
end
