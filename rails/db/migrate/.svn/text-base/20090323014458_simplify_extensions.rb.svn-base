class SimplifyExtensions < ActiveRecord::Migration
  def self.up
    add_column :legislators, :extension, :string
    add_column :issues, :extension, :string
    remove_column :legislators, :extension_id
    remove_column :issues, :extension_id
    drop_table :extensions
  end

  def self.down
    create_table :extensions do |t|
      t.string :number
      t.timestamps
    end
    remove_column :issues, :extension
    remove_column :legislators, :extension
  end
end
