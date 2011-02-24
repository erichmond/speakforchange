require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase
  def setup
    @message = MessageToLegislator.create :zipcode => '12345', :state => "MA"
    @senator = Senator.create :firstname => "hilary"
    @message.deliveries.create :messageable => @senator
  end

  def test_polymorphic
    assert @senator.messages.include?(@message)
  end

  def test_fill_sphinx_fields
    assert @message.reload.legislator_name
  end
end
