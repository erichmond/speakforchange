class AddIndexesToMessages < ActiveRecord::Migration
  def self.up
    add_index :messages, :state
    add_index :messages, :zipcode
    add_index :messages, :password
  end

  def self.down
    remove_index :messages, :column => :password
    remove_index :messages, :column => :zipcode
    remove_index :messages, :column => :state
  end
end
