class AddTypeToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :type, :string, :default => "MessageToLegislator"
  end

  def self.down
    remove_column :messages, :type
  end
end
