require 'test_helper'

class TagTest < Test::Unit::TestCase

  def test_normalize_tag_names
    @tag = Tag.new(:name => "Gun control")
    assert_equal "gun control", @tag.name
  end

end

