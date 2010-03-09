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
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end