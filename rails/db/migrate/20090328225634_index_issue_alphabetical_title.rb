class IndexIssueAlphabeticalTitle < ActiveRecord::Migration
  def self.up
    add_index :issues, :alphabetical_title
    add_index :issues, :deliveries_count
  end

  def self.down
    remove_index :issues, :column => :deliveries_count
    remove_index :issues, :column => :alphabetical_title
  end
end
