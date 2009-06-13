class Trail
  
  # Attributes:
  #   x: current horizontal position. if nil, trail is placed randomly out of frame
  #   y: current vertical position. if nil, trail is placed randomly out of frame
  #   speed: larger numbers go faster. default: random
  #   length: length of the non-fading portion of the trail. default: random
  #   pattern:
  #     an array of boolean variables that define the highlighted pattern.
  #     the array maps to the head of the trail, so
  #     [t, f, f, t, f] on a trail of 6 would give on a downwards trail
  #     -
  #     -
  #     #
  #     -
  #     -
  #     # <- head
  #     default: [t], only the head is highlighted
  #     TODO: allow pattern to take colours
  #   color:
  #     color of the trail. takes a 32bit integer in the format 0xAARRGGBB
  #     or 3 or 4 element array in the format [R, G, B] or [A, R, G, B]
  #     A assumed to be 255 in the 3 element case
  #     default: [0, 255, 0]
  #   highlight_color: see color. default: [255, 255, 255]
  #   direction: the direction the trail is heading.
  #       0
  #     3 + 1
  #       2
  #     default: 2
  
  attr_accessor :x, :y, :speed, :length, :color, :highlight_color, :pattern, :direction, :x_delta, :y_delta, :glyphs
  
  def initialize(window, options = {})
    @window = window
    @glyphs = []
    
    defaults = {
      :x => nil,
      :y => nil,
      :speed => (2..8),
      :length => (3..10),
      :color => [0, 255, 0],
      :pattern => [true],
      :direction => 2
    }
    
    defaults.merge(options).each do |k, v|
      self.send("#{k}=", v)
    end
    @padded_pattern = @pattern + [false]
    
    set_starting_position
    set_movement_offsets
    
    @t = 100
    
    add_glyph
  end
  
  def length=(value)
    if value.is_a? Range
      @length = value.to_a.rand
    else
      @length = value
    end
  end
  
  def speed=(value)
    if value.is_a? Range
      @speed = value.to_a.rand
    else
      @speed = value
    end
  end
  
  def draw
    @t -= @speed
    
    @glyphs.map do |g|
      g.draw
      @glyphs.delete(g) if !g.visible?
    end
      
  end
  
  def add_glyph
    if @glyphs.reject { |g| g.fading? }.size < @length
      @glyphs << Glyph.new(@window, self, @x, @y)
      apply_pattern
    end
  end
  
  def apply_pattern
    @glyphs.reverse[0, @padded_pattern.length].zip(@padded_pattern) do |g, h|
      g.highlighted = h
    end
  end
  
  
  
  
  
  private
  
  def set_starting_position
    case direction
    when 0 # up
      @x = rand(@window.width)
      @y = @window.height
    when 1 # left
      @x = 0
      @y = rand(@window.height)
    when 2 # down
      @x = rand(@window.width)
      @y = 0
    when 3 # right
      @x = @window.width
      @y = rand(@window.height)
    end
  end
  
  def set_movement_offsets
    case direction
    when 0 # up
      @x_delta = 0
      @y_delta = -1
    when 1 # left
      @x_delta = -1
      @y_delta = 0
    when 2 # down
      @x_delta = 0
      @y_delta = 1
    when 3 # right
      @x_delta = 1
      @y_delta = 0
    end
  end
  

  
  
end
