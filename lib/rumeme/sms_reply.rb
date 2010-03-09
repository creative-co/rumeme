require 'message_status'

module Rumeme
  # This class represents an SMS reply.
  class SmsReply
    #attr_accessor :phone_number, :message, :message_id, :when, :status
    attr_reader :phone_number, :message, :message_id, :when, :status

    #Constructor.
    def initialize phone_number, message, message_id, _when, status
      @phone_number, @message, @message_id, @when, @status = phone_number, message, message_id, _when, status
    end

    # Unescape any escaped characters in the string.
    def self.unescape line
      line.nil? ? nil : line.gsub('\n', "\n").gsub('\r', "\r").gsub('\\\\', "\\")
    end

    #Parse a reply from a string.
    # Format is: messageID phone when message
    # Or if no message ID: phone when message
    # Or if delivery receipt: messageID messageStatus when
    # php suxx. reimplement using regex
    def self.parse line, use_message_id
      p "parsing line: #{line}. #{use_message_id}."
      message_id = 0;
      status = MessageStatus::NONE

      prev_idx = 0;
      if (idx = line.index(' ')) == nil
        return nil
      end

      if (use_message_id)
        if line[0..idx] =~ /\d+/
          message_id = line[0..idx].to_i
        else
          return nil
        end

        prev_idx = idx + 1
        if (idx = line.index(' ', idx + 1)) == nil
          return nil
        end
      end

      phone = line[prev_idx .. idx - 1]

      if phone.length == 1
        status = case phone  # why not use to_i ??
          when "1"
            MessageStatus::PENDING
          when "2"
            MessageStatus::DELIVERED
          when "3"
            MessageStatus::FAILED
          else
            nil
        end
        phone = ""
      end

      prev_idx = idx + 1;
      idx = line.index(' ', idx + 1) || line.length

      if line[prev_idx .. idx-1] =~ /\d+/
        when_ = $&.to_i
      else
        return nil
      end

      message = (status != MessageStatus::NONE) || (line.length < idx + 2) ? "" : unescape(line[idx + 1 .. -1])
      return SmsReply.new(phone, message, message_id, when_, status)
    end
  end
end