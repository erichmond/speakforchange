class UpdateDeliveriesCounts < ActiveRecord::Migration
  def self.up
    Legislator.reset_column_information
    Legislator.all.each do |x|
      x.write_attribute('deliveries_count', x.messages.size)
      x.save(false)
    end
    Issue.reset_column_information
    Issue.all.each do |x|
      x.write_attribute('deliveries_count', x.messages.size)
      x.save(false)
    end
  end

  def self.down
  end
end
