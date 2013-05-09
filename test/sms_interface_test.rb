$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require "rubygems"
require 'shoulda'
require "rumeme"

include Rumeme

class SmsInterfaceTest < Test::Unit::TestCase

end