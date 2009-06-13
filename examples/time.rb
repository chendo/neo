$:.unshift(File.dirname(__FILE__) + "/..") 
require 'lib/neo'

# Time encoded in matrix time
# 24 hour time
# First digit in the first quarter starting from the left, second digit in the second quarter, etc
# Count the number of highlighted glyphs in each trail to get the digit

Neo.init
Neo.max_trails = 60
Neo.spawn do
  code = Time.now.strftime("%H%M").split(//).map { |i| i.to_i }
  index = rand(4)
  pattern = [true] * code[index]
  x = index * width / 4 + rand(width / 4)
  Trail.new(self, :pattern => pattern, :length => pattern.length + rand(3), :x => x, :speed => 2..7)
end

Neo.run
