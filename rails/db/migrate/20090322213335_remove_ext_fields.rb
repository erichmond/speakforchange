class RemoveExtFields < ActiveRecord::Migration
  def self.up
    remove_column :issues, :ext
    remove_column :legislators, :ext
  end

  def self.down
    add_column :legislators, :ext
    add_column :issues, :ext
  end
end
