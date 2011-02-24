class MessageableIds < ActiveRecord::Migration
  def self.up
    rename_column :messages, :legislator_ids, :messageable_ids
  end

  def self.down
    rename_column :messages, :messageable_ids, :legislator_ids
  end
end
