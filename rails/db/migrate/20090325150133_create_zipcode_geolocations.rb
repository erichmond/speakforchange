class CreateZipcodeGeolocations < ActiveRecord::Migration
  def self.up
    create_table :zipcode_geolocations do |t|
      t.string :zipcode
      t.float :lat
      t.float :lng

      t.timestamps
    end
    add_index :zipcode_geolocations, :zipcode
  end

  def self.down
    drop_table :zipcode_geolocations
  end
end
