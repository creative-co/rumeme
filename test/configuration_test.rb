$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require "rubygems"
require 'shoulda'
require "rumeme"

include Rumeme

class ConfigurationTest < Test::Unit::TestCase
  context "has attributes" do
    setup do
      @rumeme_configuration = Configuration.new
    end

    should "have username attribute" do
      assert_respond_to @rumeme_configuration, :username
    end

    should "have password attribute" do
      assert_respond_to @rumeme_configuration, :password
    end

    should "have use_message_id attribute" do
      assert_respond_to @rumeme_configuration, :use_message_id
    end

    should "have secure attribute" do
      assert_respond_to @rumeme_configuration, :secure
    end

    should "have replies_auto_confirm attribute" do
      assert_respond_to @rumeme_configuration, :replies_auto_confirm
    end

    should "have long_messages_strategy attribute" do
      assert_respond_to @rumeme_configuration, :long_messages_strategy
    end
  end
end
