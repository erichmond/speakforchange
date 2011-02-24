# creates a few random test messages
Representative.all(:order => "rand()", :limit => 50).each do  |x|
  zipcode = (1..5).map { rand(10).to_i }.join
  m = MessageToLegislator.new :zipcode => zipcode, :file => "test.mp3", :state => x.state
  m.save
  senators = Senator.all( :conditions => {:state => m.state} )
  ([x] + senators)[0,3].each do |legislator|
    m.deliveries.create :messageable => legislator
  end
end
