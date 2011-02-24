class AddExtensionFields < ActiveRecord::Migration
  def self.up
    add_column :legislators, :ext, :string
    add_column :issues, :ext, :string
  end

  def self.down
    remove_column :issues, :ext
    remove_column :legislators, :ext
  end
end
