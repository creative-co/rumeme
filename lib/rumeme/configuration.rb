module Rumeme
  # Holds configuration attributes for sms interface
  class Configuration
    attr_accessor :username
    attr_accessor :password
    attr_accessor :use_message_id
    attr_accessor :secure
    attr_accessor :replies_auto_confirm

    #
    # possible values
    # :send - sends messages as is without any modification
    # :split - splits messages into small (less than 160 ch) messages
    # :cut - sends only first 160 symbols 
    attr_accessor :long_messages_strategy

    def initialize
      @replies_auto_confirm = true
      @long_messages_strategy = :send
    end
  end
end

