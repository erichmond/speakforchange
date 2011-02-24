class AsteriskUid < ActiveRecord::Migration
  def self.up
    add_column :messages, :asterisk_uid, :string
  end

  def self.down
    remove_column :messages, :asterisk_uid
  end
end
