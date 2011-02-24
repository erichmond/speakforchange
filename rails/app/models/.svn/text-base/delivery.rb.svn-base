class Delivery < ActiveRecord::Base
  belongs_to :message
  belongs_to :messageable, :polymorphic => true, :counter_cache => true

  after_save :fill_sphinx_fields_on_message

  # This is slightly inefficient for a message with multiple deliveries, but
  # that's OK for now.

  def fill_sphinx_fields_on_message
    message.fill_sphinx_fields
    message.save
  end
end
