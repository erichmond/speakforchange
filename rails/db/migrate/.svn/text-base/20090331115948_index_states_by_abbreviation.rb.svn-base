class IndexStatesByAbbreviation < ActiveRecord::Migration
  def self.up
    add_index :states, :abbreviation
  end

  def self.down
    remove_index :states, :column => :abbreviation
  end
end
