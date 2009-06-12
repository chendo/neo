class Trail
  attr_accessor :x, :y, :speed, :length
  def initialize(window, speed = rand(4) + 0.3, length = rand(6) + 3)
    @window = window
    @z_order = rand(3)
    @glyphs = []
    @x = rand(40) * 20 #rand(700) - 30
    @y = -100
    @speed = speed
    @t = speed
    @length = length
    add_glyph
  end
  
  def draw
    @t -= 1
    @glyphs.each do |g|
      g.draw
      if g.opacity <= 0
        @glyphs.delete(g)
      end
    end
        
    if @t <= 0
      @t = @speed
      @y += 20
      if visible?
        add_glyph
      else
        puts "not visible"
        @window.expire_trail(self)
      end
    end
  end
  
  def head_visible?
    @y < @window.height
  end
  
  
  def visible?
    @glyphs.any? { |g| g.visible? }
  end
  
  
  def add_glyph
    @glyphs.last.white = false unless @glyphs.empty?
    @glyphs << Glyph.new(@window, self, @x, @y)
    if @glyphs.size > @length
      @glyphs[@glyphs.size - @length].fading = true
    end
  end
  
  
  
  
end