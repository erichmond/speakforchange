class RemoveBlobFromMessage < ActiveRecord::Migration
  def self.up
    remove_column :messages, :legislators
  end

  def self.down
    add_column :messages, :legislators, :text
  end
end
