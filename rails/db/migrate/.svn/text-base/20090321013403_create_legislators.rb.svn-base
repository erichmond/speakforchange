class CreateLegislators < ActiveRecord::Migration
  def self.up
    create_table :legislators do |t|

      t.string :title
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :name_suffix
      t.string :nickname
      t.string :party
      t.string :state
      t.integer :district
      t.string :senate_class
      t.boolean :in_office
      t.string :gender
      t.string :phone
      t.string :fax
      t.string :website
      t.string :webform
      t.string :email
      t.string :congress_office
      t.string :bioguide_id
      t.integer :votesmart_id
      t.string :fec_id
      t.integer :govtrack_id
      t.string :crp_id
      t.string :eventful_id
      t.string :sunlight_old_id
      t.string :twitter_id
      t.string :congresspedia_url
      t.string :youtube_url
      t.string :official_rss

      t.timestamps
    end
  end

  def self.down
    drop_table :legislators
  end
end
