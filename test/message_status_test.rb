$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require "rubygems"
require 'shoulda'
require "rumeme"

class MessageStatusTest < Test::Unit::TestCase
  should "correctly assign MessageStatus constants" do
    assert_equal Rumeme::MessageStatus::NONE, 0
    assert_equal Rumeme::MessageStatus::PENDING, 1
    assert_equal Rumeme::MessageStatus::DELIVERED, 2
    assert_equal Rumeme::MessageStatus::FAILED, 3
  end
end