class CheckForImageFiles < ActiveRecord::Migration
  def self.up
    Legislator.all.each do |x|
      x.check_for_image_file
    end
  end

  def self.down
  end
end
