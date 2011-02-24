class SubclassLegislator < ActiveRecord::Migration
  def self.up
    add_column :legislators, :type, :string
    Legislator.reset_column_information
    Legislator.all.each do |x|
      if x.district == 0
        x.district = nil
        x.write_attribute('type', "Senator")
        x.save
      else
        x.write_attribute('type', "Representative")
        x.save
      end
    end
  end

  def self.down
    remove_column :legislators, :type
  end
end
