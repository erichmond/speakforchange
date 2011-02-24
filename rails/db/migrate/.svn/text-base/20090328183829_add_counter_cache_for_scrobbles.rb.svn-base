class AddCounterCacheForScrobbles < ActiveRecord::Migration
  def self.up
    add_column :messages, :plays_count, :integer, :default => 0
  end

  def self.down
    remove_column :messages, :plays_count
  end
end
