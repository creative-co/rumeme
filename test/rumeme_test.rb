#units test for rumeme

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require "rumeme"

include Rumeme

class RumemeTest < Test::Unit::TestCase
  def test_parse_reply_with_id
    result = SmsReply.parse("12 79270123456 100 asdfgh", true)
    assert 12, result.message_id
    assert '79270123456', result.phone_number
    assert 100, result.when
    assert 'asdfgh', result.message
    assert MessageStatus::NONE, result.status
  end

  def test_parse_reply_without_id
    result = SmsReply.parse("79270123456 100 asdfgh", false)
    assert_nil result.message_id
    assert '79270123456', result.phone_number
    assert 100, result.when
    assert 'asdfgh', result.message
    assert MessageStatus::NONE, result.status
  end

  def test_parse_delivery_report_pending
    result = SmsReply.parse("12 1 100", true)
    assert 12, result.message_id
    assert MessageStatus::PENDING, result.status
    assert 100, result.when
  end
end