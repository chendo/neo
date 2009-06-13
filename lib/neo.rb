$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'gosu'
require 'neo/extensions'
require 'neo/window'
require 'neo/trail'
require 'neo/glyph'


class Neo
  VERSION = '0.0.1'
  
  class << self
    attr_accessor :max_trails
    
    def init
      @window = Window.new(self)
    end
    
    def method_missing(method, *args, &block)
      @window.send(method, *args, &block)
    end
    

    def run(&block)
      @window.block = block
      @window.show
    end
  end
end