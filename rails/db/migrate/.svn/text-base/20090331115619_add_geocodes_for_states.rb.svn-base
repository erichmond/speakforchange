class AddGeocodesForStates < ActiveRecord::Migration
  def self.up
    add_column :states, :lat, :float
    add_column :states, :lng, :float
    State.reset_column_information
    State.all.each do |s|
      s.geocode
    end
  end

  def self.down
    remove_column :states, :lng
    remove_column :states, :lat
  end
end
