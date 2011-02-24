class AddPasswordFieldToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :password, :string
  end

  def self.down
    remove_column :messages, :password
  end
end
