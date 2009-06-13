require File.dirname(__FILE__) + '/spec_helper.rb'

require 'neo'

describe Glyph do
  before do
    window_options = {
      :pixel_width => 800,
      :pixel_height => 600,
      :scale => 0.15,
      :glyph_width => 128,
      :glyph_height => 128,
      :glyphs => stub(:rand => stub)
    }
    window_options.instance_eval do 
      self[:width] = self[:pixel_width] / (self[:glyph_width] * self[:scale])
      self[:height] = self[:pixel_height] / (self[:glyph_height] * self[:scale])
    end

    
    @window = stub(window_options)     

     
    window_options.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
    
    trail_options = {
      :direction => :down,
      :x => 8,
      :y => 0,
      :color => [0, 255, 0],
      :highlight_color => [255, 255, 255],
      :speed => 3,
      :length => 7,
      :pattern => [true, false, true]
    }
    
    @trail = stub(trail_options)
  end  
  
  describe "creating a glyph" do
    before do
      @glyph = Glyph.new(@window, @trail)
    end
    
    it "should set x and y to the trail's current x and y" do
      @glyph.x.should == @trail.x
      @glyph.y.should == @trail.y
    end
    
    it "should have a random glyph" do
      @glyph.glyph.should_not be_nil 
    end
    
    it "should reference trail" do
      @glyph.instance_variable_get(:@trail).should be(@trail)
    end
    
    it "should reference window" do
      @glyph.instance_variable_get(:@window).should be(@window)
    end
    
    it "should have an opacity of 255" do
      @glyph.instance_variable_get(:@opacity).should be(255)
    end
    
    describe "drawing" do
      describe "when offscreen" do
        before do
          @glyph.x = @window.width + 1
          @glyph.y = -1
        end
        
        it "should not draw" do
          @glyph.glyph = mock.expects(:draw).never
          @glyph.draw
        end
      end
      
      describe "when onscreen" do
        before do
          @goal_x = @glyph.x = rand(@window.width)
          @goal_y = @glyph.y = rand(@window.height)
        end
        
        it "should draw at those coordinates" do
          @glyph.glyph = mock
          @glyph.glyph.expects(:draw).once
          @glyph.stubs(:x_pixels).once.returns(@goal_x)
          @glyph.stubs(:y_pixels).once.returns(@goal_y)
          
          @glyph.draw
        end
          
      end
    end
  end
end