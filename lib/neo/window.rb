class Window < Gosu::Window
  attr_accessor :glyphs, :block
  def initialize
    super(800, 600, false)
    self.caption = "Neo"
    load_glyphs
    @trails = []
    25.times { spawn }
  end
  
  def load_glyphs
    @glyphs = []
    Dir.glob("glyphs/*.png").each do |file|
      @glyphs << Gosu::Image.new(self, file)
    end
    p @glyphs
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