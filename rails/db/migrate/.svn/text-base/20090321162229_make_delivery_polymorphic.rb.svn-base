class MakeDeliveryPolymorphic < ActiveRecord::Migration
  def self.up
    remove_column :deliveries, :legislator_id
    add_column :deliveries, :messageable_type, :string
    add_column :deliveries, :messageable_id, :integer
  end

  def self.down
    remove_column :deliveries, :messageable_id
    remove_column :deliveries, :messageable_type
    add_column :deliveries, :legislator_id
  end
end
