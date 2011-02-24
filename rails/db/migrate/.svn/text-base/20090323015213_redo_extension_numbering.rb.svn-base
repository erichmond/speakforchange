class RedoExtensionNumbering < ActiveRecord::Migration
  def self.up
    Legislator.all.each_with_index do |x, i|
      x.update_attribute :extension, (i + 100).to_s
    end
  end

  def self.down
  end
end
