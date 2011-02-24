# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090331115948) do

  create_table "deliveries", :force => true do |t|
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "messageable_type"
    t.integer  "messageable_id"
  end

  add_index "deliveries", ["messageable_id", "messageable_type"], :name => "index_deliveries_on_messageable_id_and_messageable_type"
  add_index "deliveries", ["messageable_type", "messageable_id"], :name => "index_deliveries_on_messageable_type_and_messageable_id"

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
    t.integer  "deliveries_count",   :default => 0
    t.string   "alphabetical_title"
  end

  add_index "issues", ["alphabetical_title"], :name => "index_issues_on_alphabetical_title"
  add_index "issues", ["deliveries_count"], :name => "index_issues_on_deliveries_count"

  create_table "legislators", :force => true do |t|
    t.string   "title"
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.string   "name_suffix"
    t.string   "nickname"
    t.string   "party"
    t.string   "state"
    t.integer  "district"
    t.string   "senate_class"
    t.boolean  "in_office"
    t.string   "gender"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "webform"
    t.string   "email"
    t.string   "congress_office"
    t.string   "bioguide_id"
    t.integer  "votesmart_id"
    t.string   "fec_id"
    t.integer  "govtrack_id"
    t.string   "crp_id"
    t.string   "eventful_id"
    t.string   "sunlight_old_id"
    t.string   "twitter_id"
    t.string   "congresspedia_url"
    t.string   "youtube_url"
    t.string   "official_rss"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "extension"
    t.integer  "deliveries_count",  :default => 0
    t.string   "image_file"
  end

  create_table "messages", :force => true do |t|
    t.string   "zipcode"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "district"
    t.string   "asterisk_uid"
    t.text     "messageable_ids"
    t.string   "ext"
    t.string   "password"
    t.string   "type",            :default => "MessageToLegislator"
    t.string   "title"
    t.float    "lat"
    t.float    "lng"
    t.integer  "duration"
    t.string   "caller_id"
    t.string   "cname"
    t.integer  "plays_count",     :default => 0
    t.text     "legislator_name"
    t.text     "issue_name"
    t.boolean  "converted",       :default => false
    t.string   "link"
  end

  add_index "messages", ["lat", "lng"], :name => "index_messages_on_lat_and_lng"
  add_index "messages", ["password"], :name => "index_messages_on_password"
  add_index "messages", ["state"], :name => "index_messages_on_state"
  add_index "messages", ["zipcode"], :name => "index_messages_on_zipcode"

  create_table "plays", :force => true do |t|
    t.string   "ip_address"
    t.integer  "message_id"
    t.datetime "created_at"
  end

  add_index "plays", ["message_id", "ip_address"], :name => "index_plays_on_message_id_and_ip_address"

  create_table "states", :force => true do |t|
    t.string   "abbreviation"
    t.string   "name"
    t.integer  "messages_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "states", ["abbreviation"], :name => "index_states_on_abbreviation"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "zipcode_geolocations", :force => true do |t|
    t.string   "zipcode"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zipcode_geolocations", ["zipcode"], :name => "index_zipcode_geolocations_on_zipcode"

end
