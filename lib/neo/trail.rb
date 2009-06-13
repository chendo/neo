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
  #   direction: the direction the trail is heading. :up, :down, :left, :right. default: :down
  
  attr_accessor :x, :y, :speed, :length, :color, :highlight_color, :pattern, :direction, :x_delta, :y_delta, :glyphs
  
  def initialize(window, options = {})
    @window = window
    @glyphs = []
    
    defaults = {
      :x => nil,
      :y => nil,
      :speed => (2..15),
      :length => (3..10),
      :color => [0, 255, 0],
      :highlight_color => [255, 255, 255],
      :pattern => [true],
      :direction => :down
    }
    
    defaults.merge(options).each do |k, v|
      self.send("#{k}=", v)
    end
    

    raise InvalidDirection unless [:up, :down, :left, :right].include? @direction
    
    @padded_pattern = @pattern + [false]
    
    set_starting_position
    set_movement_deltas
    
    @t = 20
    
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
    
    @glyphs.each do |g|
      g.draw
    end
    
    @glyphs.reject! { |g| !g.visible? }
    
    return if @t > 0

    if @glyphs.all? { |g| g.off_screen? }
      return @window.expire_trail(self)
    end
    @t = 20
    update_position
    add_glyph
  end
  
  def update_position
    @x += @x_delta
    @y += @y_delta
  end
  
  
  
  def add_glyph
    if @glyphs.reject { |g| g.fading? }.size == @length
      @glyphs[@length - 1].fading = true
    end
    @glyphs.unshift Glyph.new(@window, self)
    apply_pattern
  end
  
  def apply_pattern
    @glyphs[0, @padded_pattern.length].zip(@padded_pattern) do |g, h|
      g.highlighted = h
    end
  end
  
  private
  
  def set_starting_position
    case @direction
    when :up
      @x = rand(@window.width)
      @y = @window.height
    when :right
      @x = 0
      @y = rand(@window.height)
    when :down
      @x = rand(@window.width)
      @y = 0
    when :left
      @x = @window.width
      @y = rand(@window.height)
    end
  end
  
  def set_movement_deltas
    case @direction
    when :up
      @x_delta = 0
      @y_delta = -1
    when :left
      @x_delta = -1
      @y_delta = 0
    when :down
      @x_delta = 0
      @y_delta = 1
    when :right
      @x_delta = 1
      @y_delta = 0
    end
  end
  

  
  
end

class Trail::InvalidDirection < Exception; end