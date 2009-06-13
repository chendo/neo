$:.unshift(File.dirname(__FILE__) + "/..") 
require 'lib/neo'

Neo.init
Neo.max_trails = 60
Neo.spawn do
  code = Time.now.strftime("%H%M").split(//).map { |i| i.to_i }
  index = rand(4)
  pattern = [true, [false] * code[index], true].flatten
  x = index * width / 4 + rand(width / 4)
  Trail.new(self, :pattern => pattern, :length => pattern.length + rand(3), :x => x, :speed => 2..7)
end

Neo.run
