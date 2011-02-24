class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.integer :message_id
      t.integer :legislator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :deliveries
  end
end
