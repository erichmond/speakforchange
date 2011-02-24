class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.string :ip_address
      t.integer :message_id

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :plays
  end
end
