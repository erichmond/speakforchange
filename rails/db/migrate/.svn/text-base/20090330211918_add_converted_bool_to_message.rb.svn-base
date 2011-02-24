class AddConvertedBoolToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :converted, :boolean, :default => false
    Message.reset_column_information
    Message.all.each do |x|
      x.converted = true
      x.save
    end
  end

  def self.down
    remove_column :messages, :converted
  end
end
