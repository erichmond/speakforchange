class StateOnMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :state, :string
  end

  def self.down
    remove_column :messages, :state
  end
end
