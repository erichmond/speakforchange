class Play < ActiveRecord::Base
  belongs_to :message, :counter_cache => true
  validates_presence_of :ip_address, :message
  validates_uniqueness_of :ip_address, :scope => :message_id
end
