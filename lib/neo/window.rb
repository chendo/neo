class Window < Gosu::Window
  attr_accessor :glyphs, :block, :pixel_width, :pixel_height, :glyph_width, :glyph_height, :scale
  def initialize(width = 800, height = 600, fullscreen = false, scale = 0.10)
    super(width, height, fullscreen)
    
    
    @pixel_width = width
    @pixel_height = height
    @scale = scale
    @glyph_height = 128
    @glyph_width = 128
    
    self.caption = "Neo"
    load_glyphs
    @trails = []
    40.times { spawn }
  end
  
  def load_glyphs
    @glyphs = []
    Dir.glob("glyphs/*.png").each do |file|
      @glyphs << Gosu::Image.new(self, file)
    end
  end
  
  def update
    
  end
  
  def width
    @width ||= @pixel_width / (@glyph_width * @scale)
  end
  
  def height
    @height ||= @pixel_height / (@glyph_height * @scale)
  end
  
  
  def draw
    @trails.each do |trail|
      trail.draw
    end
  end
  
  def expire_trail(trail)
    @trails.delete(trail)
    spawn
  end
  
  
  
  def spawn
    @trails << Trail.new(self, :pattern => [true, false, false, true], :length => 4..15)
  end
  
  
end