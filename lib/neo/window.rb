class Window < Gosu::Window
  attr_accessor :glyphs, :block, :pixel_width, :pixel_height, :glyph_width, :glyph_height, :scale
  def initialize(neo, width = 800, height = 600, fullscreen = false, scale = 0.15)
    super(width, height, fullscreen)
    
    
    @pixel_width = width
    @pixel_height = height
    @scale = scale
    @glyph_height = 128
    @glyph_width = 128
    @neo = neo
    
    self.caption = "Neo"
    load_glyphs
    @trails = []
  end
  
  def load_glyphs
    @glyphs = []
    Dir.glob(File.dirname(__FILE__) + "/../../glyphs/*.png").each do |file|
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
    spawn if rand(20) == 1
    @trails.each do |trail|
      trail.draw
    end
  end
  
  def expire_trail(trail)
    @trails.delete(trail)
    spawn
  end
  
  def spawn(&block)
    @spawn = block if block_given?
    @trails << instance_eval(&@spawn) if @neo.max_trails > @trails.size
  end
  
  
end