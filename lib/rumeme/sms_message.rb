module Rumeme
  # This class represents an SMS message.
  class SmsMessage
    attr_reader :phone_number, :message, :message_id, :delay, :validity_period, :delivery_report

    # Constructor.
    def initialize phone_number, message, message_id, delay, validity_period, delivery_report
      @phone_number, @message, @message_id, @delay, @validity_period, @delivery_report = phone_number, message, message_id, delay, validity_period, delivery_report
      @message = message.gsub("\n",'\n').gsub("\r",'\r').gsub("\\",'\\\\')
    end
  end
end