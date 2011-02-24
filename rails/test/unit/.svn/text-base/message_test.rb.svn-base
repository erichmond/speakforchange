require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def test_create_message
    @message = Message.create!
    assert @message.valid?
    assert @message.password
  end

  def test_subclasses
    @message = MessageToLegislator.create
    assert @message.is_a?(Message)
    assert @message.is_a?(MessageToLegislator)
  end

  def test_geocode_message
    @message = Message.new :zipcode => "02139", :title => "Bailout"
    assert ! ZipcodeGeolocation.find_by_zipcode(@message.zipcode)

    @message.geocode
    assert_equal 42.3647559, @message.lat
    assert_equal -71.1032591,  @message.lng

    # should cache this data in geocode table
    assert ZipcodeGeolocation.find_by_zipcode(@message.zipcode)
  end

  def test_generate_password
    m = Message.new :zipcode => '12345'
    m.generate_password
    assert_not_nil m.password
  end

  def xtest_increment_state_message_count
    @message = Message.create! :state => 'MA'
    assert_equal 1, State.find_by_abbreviation('MA').messages_count
  end
end
