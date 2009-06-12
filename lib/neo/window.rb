class Window < Gosu::Window
  attr_accessor :glyphs, :block, :width, :height
  def initialize(width = 800, height = 600, fullscreen = false, scale = 0.15)
    super(width, height, fullscreen)
    @width = width
    @height = height
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
    @trails << Trail.new(self)
  end
  
  
end