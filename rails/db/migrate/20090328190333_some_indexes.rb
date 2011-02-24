class SomeIndexes < ActiveRecord::Migration
  def self.up
    add_index :plays, [:message_id, :ip_address]
  end

  def self.down
    remove_index :plays, :column => :message_id
  end
end
