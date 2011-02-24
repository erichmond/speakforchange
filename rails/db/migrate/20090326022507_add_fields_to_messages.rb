class AddFieldsToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :duration, :integer
    add_column :messages, :caller_id, :string
    add_column :messages, :cname, :string
  end

  def self.down
    remove_column :messages, :cname
    remove_column :messages, :caller_id
    remove_column :messages, :duration
  end
end
