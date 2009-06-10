class Trail
  attr_accessor :x, :y, :speed
  def initialize(window, speed = rand(6) + 1)
    @window = window
    @z_order = rand(3)
    @glyphs = []
    @x = rand(40) * 20 #rand(700) - 30
    @y = -100 + rand(20)
    @speed = speed
    @t = speed
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
      if @y < 700
        add_glyph
      else
        @window.expire_trail(self) if @glyphs.empty?
      end
    end
  end
  
  def add_glyph
    @glyphs.last.white = false unless @glyphs.empty?
    @glyphs << Glyph.new(@window, self, @x, @y)
  end
  
  
  
  
end