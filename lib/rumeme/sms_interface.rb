require "net/http"
require "net/https"
require 'rubygems'
require 'nokogiri'
require 'generator'

module Rumeme

  # This is the main class used to interface with the M4U SMS messaging server.
  class SmsInterface
    class BadServerResponse < StandardError; end

    # allow_splitting, allow_long_messages, response_code, response_message, username, password, use_message_id, secure, http_connection, server_list, message_list,
    # http_proxy, http_proxy_port, http_proxy_auth, https_proxy, https_proxy_port, https_proxy_auth, text_buffer,

    # Constructor.
    #
    # The allowSplitting parameter determines whether messages over
    # 160 characters will be split over multiple SMSes or truncated.
    #
    # The allowLongMessages parameter enables messages longer than 160
    # characters to be sent as special concatenated messages. For this
    # to take effect, the allowSplitting parameter must be set to false.
    def initialize
      Rumeme.configuration.tap{ |cfg|
        @username = cfg.username
        @password = cfg.password
        @use_message_id = cfg.use_message_id
        @secure = cfg.secure
        @long_messages_strategy = cfg.long_messages_strategy
        @replies_auto_confirm = cfg.replies_auto_confirm
      }

      @response_code = -1
      @response_message = nil
      @message_list = []
      @server_list = ["smsmaster.m4u.com.au", "smsmaster1.m4u.com.au", "smsmaster2.m4u.com.au"]

      @long_messages_processor = case @long_messages_strategy
        when :send
          lambda {|message| [message]}
        when :cut
          lambda {|message| [message[0..159]]}
        when :split
          lambda {|message| SmsInterface.split_message message}
      end
    end

    # Add a message to be sent.
    def add_message args
      phone_number = self.class.strip_invalid(args[:phone_number]) #not good idea, modifying original args, from outer scope (antlypls)
      message = args[:message]

      raise ArgumentError.new("phone_number is empty") if phone_number.nil? || phone_number.empty?
      raise ArgumentError.new("message is empty") if message.nil? || message.empty?

      messages = process_long_message(message)
      @message_list.concat(messages.map{|msg| SmsMessage.new(args.merge({:message => msg, :phone_number => phone_number}))})
    end

    # Clear all the messages from the list.
    def clear_messages
      @message_list.clear
    end

    def open_server_connection server
      port, use_ssl = @secure ? [443, true] : [80, false]

      http_connection =  Net::HTTP.new(server, port)
      http_connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http_connection.use_ssl = use_ssl
      http_connection
    end

    # Change the password on the local machine and server.
    # not implemented
    def change_password
      raise 'Not Implemented'
    end

    # Return the list of replies we have received.
    def check_replies
      response_message, response_code = post_data_to_server("CHECKREPLY2.0\r\n.\r\n")
      return if response_code != 150

      messages = response_message.split("\r\n")[1..-2].map{|message_line| SmsReply.parse(message_line)} # check @use_message_id
      confirm_replies_received if @replies_auto_confirm && messages.size > 0

      return messages
    end

    # sends confirmation to server
    def confirm_replies_received
      post_data_to_server "CONFIRM_RECEIVED\r\n.\r\n"
    end

    # Returns the credits remaining (for prepaid users only).
    def get_credits_remaining
      response_message, response_code = post_data_to_server("MESSAGES\r\n.\r\n")

      if response_message =~ /^(\d+)\s+OK\s+(\d+).+/
        if response_code != 100
          raise BadServerResponse.new 'M4U code is not 100'
        end
        return $2.to_i
      else
        raise BadServerResponse.new "cant parse response: #{response_message}"
      end
    end

    # Sends all the messages that have been added with the
    # add_message command.
    def send_messages
      post_string = @message_list.map(&:post_string).join
      text_buffer = "MESSAGES2.0\r\n#{post_string}.\r\n"
      response_message, response_code = post_data_to_server(text_buffer)

      raise 'error during sending messages' if response_code != 100
    end

    private

    def self.head_tail_split message, max_len
      return [message, nil] if message.length < max_len
      pattern = /\s\.,!;:-\)/
      index = message[0..max_len].rindex(pattern) || max_len
      [message[0..index], message[index+1 .. -1]]
    end

    def self.split_message_internal message
      list =[]
      sizes = Generator.new { |g|  g.yield 152; g.yield 155 while true }

      while !message.nil? do
        head, message = head_tail_split(message, sizes.next)
        list << head
      end

      list
    end

    def self.split_message message
      messages = split_message_internal message
      message_index = 1
      ["#{messages[0]}...(1/#{messages.size})"].concat(messages[1..-1].map {|msg| "(#{message_index+=1}/#{messages.size})#{msg}"})
    end

    def process_long_message message
      return [message] if message.length <= 160
      @long_messages_processor.call(message)
    end

    # Strip invalid characters from the phone number.
    def self.strip_invalid phone
      return nil if phone.nil?
      "+#{phone.gsub(/[^0-9]/, '')}"
    end

    def create_login_string # can be calculate once at initialization
      message_id_sign = @use_message_id? '#' :''
      "m4u\r\nUSER=#{@username}#{message_id_sign}\r\nPASSWORD=#{@password}\r\nVER=PHP1.0\r\n"
    end

    def post_data_to_server data
      p 'post_data_to_server'

      http_connection = open_server_connection(@server_list[0])
      text_buffer = create_login_string + data

      p "buffer: #{text_buffer}"
      headers = {'Content-Length' => text_buffer.length.to_s}

      path = '/'

      begin
        resp, data = http_connection.post(path, text_buffer, headers)
        p resp.inspect
        p data.inspect
      rescue
        p "error: #{$!}"
        raise BadServerResponse.new("error: #{$!}")
      end

      raise BadServerResponse.new('http response code != 200') if resp.code.to_i != 200

      doc = Nokogiri::HTML(data)

      raise BadServerResponse.new('bad title') if doc.xpath('//title').text != "M4U SMSMASTER"

      response_message = doc.xpath('//body').text.strip
      response_code = nil
      if response_message =~ /^(\d+)\s+/
        response_code = $1.to_i
      end

      p "latest response code: #{response_code}"
      p "response: #{response_message }"

      [response_message, response_code]
    end
  end
end