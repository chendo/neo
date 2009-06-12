class Glyph
  attr_accessor :opacity, :white, :fading
  def initialize(window, trail, x, y)
    @x = x
    @y = y
    @window = window
    @glyph = window.glyphs[rand(window.glyphs.length)]
    @trail = trail
    @opacity = 255 + (@trail.speed * 3).round
    @white = true
    @fading = false
  end
  
  def draw
    @glyph.draw(@x, @y, 1, 0.15, 0.15, Gosu::Color.new(@opacity > 255 ? 255 : @opacity, @white ? 255 : 0, 255, @white ? 255 : 0))
    @opacity -= (1 / @trail.speed * 3).round + 2 # if @fading
    change_glyph if rand(5) == 0
  end
  
  def visible?
    @y < @window.height && @opacity > 0
  end
  
  
  def change_glyph
    @glyph = @window.glyphs[rand(@window.glyphs.length)]
  end
  
  
  
end