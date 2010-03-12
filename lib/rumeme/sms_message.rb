module Rumeme
  # This class represents an SMS message.
  class SmsMessage
    attr_reader :phone_number, :message, :message_id, :delay, :validity_period, :delivery_report

    # Constructor.
    def initialize args
      # this defaults must be moved to global configuration
      defaults = {:phone_number => nil, :message => nil, :message_id => 0, :delay => 0, :validity_period => ValidityPeriod::THREE_DAYS, :delivery_report => false}
      params = defaults.merge args
      defaults.keys.each {|key| instance_variable_set("@#{key.to_s}".to_sym, params[key])}

      raise ArgumentError.new("phone_number is empty") if @phone_number.nil? || @phone_number.empty?
      raise ArgumentError.new("message is empty") if @message.nil? || @message.empty?

      @message = @message.gsub("\n",'\n').gsub("\r",'\r').gsub("\\",'\\\\')
    end
  end
end