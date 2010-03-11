module Rumeme
  # This class represents an SMS message.
  class SmsMessage
    attr_reader :phone_number, :message, :message_id, :delay, :validity_period, :delivery_report

    # Constructor.
    def initialize args
      defaults = {:phone_number => nil, :message => nil, :message_id => 0, :delay => 0, :validity_period => ValidityPeriod::THREE_DAYS, :delivery_report => false}
      params = defaults.merge args
      defaults.keys.each {|k| instance_variable_set("@#{k.to_s}".to_sym, params[k])}

      raise ArgumentError.new("phone_number is nil") if @phone_number.nil?
      raise ArgumentError.new("phone_number is empty") if @phone_number.nil? || @phone_number.empty?

      @message = @message.gsub("\n",'\n').gsub("\r",'\r').gsub("\\",'\\\\')
    end
  end
end