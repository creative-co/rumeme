module Rumeme
  # This class represents an SMS reply.
  class SmsReply
    attr_reader :phone_number, :message, :message_id, :when, :status

    #Constructor.
    def initialize phone_number, message, message_id, _when, status
      @phone_number, @message, @message_id, @when, @status = phone_number, message, message_id, _when, status
    end

    # Unescape any escaped characters in the string.
    def self.unescape line
      line.nil? ? nil : line.gsub('\n', "\n").gsub('\r', "\r").gsub('\\\\', "\\")
    end

    # Parse a reply from a string.
    # Format is: messageID phone when message /(\d+)\s(\d+)\s(\d+)\s(.+)/
    # Or if no message ID: phone when message /(\d+)\s(\d+)\s(.+)/
    # Or if delivery receipt: messageID messageStatus when /(\d+)\s(\d)\s(\d+)/
    # current implementation ignores use_message_id setting (as original code)
    def self.parse line
      p "parsing line: #{line}"

      message_id, status, message, phone, when_ = case line
        when /^(\d+)\s(\d)\s(\d+)/
          #process delivery report
          [$1.to_i, $2.to_i, nil, nil, $3.to_i]
        when /^(\d+)\s\+?(\d+)\s(\d+)\s(.+)/
          #process message with id
          [$1.to_i, MessageStatus::NONE, unescape($4), $2, $3.to_i]
        when /^\+?(\d+)\s(\d+)\s(.+)/
          #process message without id
          [nil, MessageStatus::NONE, unescape($3), $1, $2.to_i]
        else
          raise ArgumentError.new("can't parse line: #{line}")
      end

      return SmsReply.new(phone, message, message_id, when_, status)
    end

    def delivery_report?
      @status != MessageStatus::NONE
    end
  end
end