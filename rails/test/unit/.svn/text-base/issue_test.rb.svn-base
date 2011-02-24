require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  def setup
    @message = Message.create :zipcode => '12345', :state => "MA"
    @issue = Issue.create :title => "the environment"
    @message.deliveries.create :messageable => @issue
  end

  def test_polymorphic
    assert @issue.messages.include?(@message)
  end

  def test_assign_extension
    assert_equal '1001', @issue.extension
    # create a second
    @issue2 = Issue.create :title => "the bailout"
    assert_equal '1002', @issue2.extension
  end

  def test_create_alphabetical_title
    assert_equal 'environment', @issue.alphabetical_title
  end
end
