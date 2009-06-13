require 'rubygems'
require 'spec'
require 'mocha'

$:.unshift(File.dirname(__FILE__) + '/../lib')

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :rr
  # config.mock_with :flexmock
  config.mock_with :mocha
end

def p(*objs)
  puts objs.map { |o| inspect.gsub('<', '&lt;').gsub('>', '&gt;') }.join("\n")
end