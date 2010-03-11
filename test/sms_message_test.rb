$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require "rubygems"
require 'shoulda'
require "rumeme"

class SmsMessageTest < Test::Unit::TestCase
  context "SmsMessage constructor" do
    should "correctly assign all parameters" do
      sms = SmsMessage.new :phone_number => "12345678901",
                           :message => "qwertasdfzxcv",
                           :message_id => 100,
                           :delay => 10,
                           :validity_period => ValidityPeriod::MINIMUM,
                           :delivery_report => true

      assert_equal "12345678901", sms.phone_number
      assert_equal "qwertasdfzxcv", sms.message
      assert_equal 100, sms.message_id
      assert_equal 10, sms.delay
      assert_equal ValidityPeriod::MINIMUM, sms.validity_period
      assert_equal true, sms.delivery_report
    end

    should "correctly assign default values" do
      sms = SmsMessage.new :phone_number => "12345678901",
                           :message => "qwertasdfzxcv"

      assert_equal "12345678901", sms.phone_number
      assert_equal "qwertasdfzxcv", sms.message
      assert_equal 0, sms.message_id
      assert_equal 0, sms.delay
      assert_equal ValidityPeriod::THREE_DAYS, sms.validity_period
      assert_equal false, sms.delivery_report

    end

  end
end