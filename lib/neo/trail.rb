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
  
  attr_accessor :x, :y, :speed, :length, :color, :highlight_color, :pattern, :direction
  
  
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
    
    set_starting_position
    set_movement_offsets
    
  end
  
  private
  
  def set_starting_position
    case direction
    when 0
      @y = @window.height
      @x = rand(@window.width / 20) * 20
    when 1
      @x = 0
      @y = rand(@window.width / 20) * 20
  end
  
  
  
end
