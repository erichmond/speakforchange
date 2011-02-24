class AddLatLngToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :lat, :float
    add_column :messages, :lng, :float
    add_index :messages, [:lat, :lng]
  end

  def self.down
    remove_index :messages, :column => [:lat, :lng]
    remove_column :messages, :lat
    remove_column :messages, :lat
  end
end
