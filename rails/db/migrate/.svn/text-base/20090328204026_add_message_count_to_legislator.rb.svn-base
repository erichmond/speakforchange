class AddMessageCountToLegislator < ActiveRecord::Migration
  def self.up
    add_column :legislators, :deliveries_count, :integer, :default => 0
    add_column :issues, :deliveries_count, :integer, :default => 0
  end

  def self.down
    remove_column :issues, :deliveries_count
    remove_column :legislators, :deliveries_count
  end
end
