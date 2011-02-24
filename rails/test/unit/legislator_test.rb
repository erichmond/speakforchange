require 'test_helper'

class LegislatorTest < ActiveSupport::TestCase
  def test_auto_create_extension
    @legislator = Senator.create :lastname => "Machiavelli"
    assert_equal "101", @legislator.extension
    assert_equal 101, Legislator.max_extension
    @legislator = Senator.create :lastname => "Machiavelli2"
    assert_equal "102", @legislator.extension
  end

  def test_counter_cache
    @legislator = Senator.create :lastname => "Machiavelli"
    assert_equal 0, @legislator.deliveries_count
    @legislator.deliveries.create
    assert_equal 1, @legislator.reload.deliveries_count
  end
end
