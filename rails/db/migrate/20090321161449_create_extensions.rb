class CreateExtensions < ActiveRecord::Migration
  def self.up
    create_table :extensions do |t|
      t.string :number

      t.timestamps
    end
  end

  def self.down
    drop_table :extensions
  end
end
