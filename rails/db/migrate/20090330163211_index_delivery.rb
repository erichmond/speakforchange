class IndexDelivery < ActiveRecord::Migration
  def self.up
    add_index :deliveries, [:messageable_id, :messageable_type]
    add_index :deliveries, [:messageable_type, :messageable_id]
  end

  def self.down
    remove_index :deliveries, :column => [:messageable_type, :messageable_id]
    remove_index :deliveries, :column => [:messageable_id, :messageable_type]
  end
end
