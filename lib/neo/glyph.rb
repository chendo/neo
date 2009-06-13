class Glyph
  attr_accessor :opacity, :highlighted, :fading, :x, :y, :glyph, :color
  def initialize(window, trail)
    @x = trail.x
    @y = trail.y
    @window = window
    @glyph = window.glyphs.rand
    @trail = trail
    @opacity = 255
    @color = trail.color
    @highlight_color = trail.highlight_color
  end
  
  def draw
    return if off_screen?
    @glyph.draw(x_pixels, y_pixels, 1, scale, scale, color)
    @opacity -= (@trail.speed) if @fading
    change_glyph if rand(10) == 0
  end

  def x_pixels
    @x_pixels ||= x * @window.glyph_width * @window.scale
  end
  
  def y_pixels
    @y_pixels ||= y * @window.glyph_height * @window.scale
  end
  
  def color
    return Gosu::Color.new(@opacity, *@highlight_color) if highlighted?
    Gosu::Color.new(@opacity, *@color)
  end
  
  def off_screen?
    x > @window.width || x < -1 || y > @window.height || y < -1
  end
  
  
  def scale
    @scale ||= @window.scale
  end

  def visible?
    @opacity > 0
  end
  
  def fading?
    @fading || false
  end
  
  def highlighted?
    @highlighted || false
  end
  
  
  
  
  def change_glyph
    @glyph = @window.glyphs[rand(@window.glyphs.length)]
  end
  
  
  
end