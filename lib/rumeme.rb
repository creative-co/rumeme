require "rumeme/configuration"
require "rumeme/message_status"
require "rumeme/validity_period"
require "rumeme/sms_message"
require "rumeme/sms_reply"
require "rumeme/sms_interface"

module Rumeme
  class << self
    attr_accessor :configuration

    def configure
      @configuration ||= Configuration.new
      yield @configuration

      raise 'unknown long_messages_strategy' unless [:split, :send, :cut].include?(@configuration.long_messages_strategy)
    end
  end
end
