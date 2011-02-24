class AddPictureFieldToLegislators < ActiveRecord::Migration
  def self.up
    add_column :legislators, :image_file, :string
    Legislator.reset_column_information
    Legislator.all.each do |x|
      x.image_file = "#{x.bioguide_id}.jpg"
      x.save
    end
  end

  def self.down
    remove_column :legislators, :image_file
  end
end
