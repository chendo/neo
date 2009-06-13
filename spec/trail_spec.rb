require File.dirname(__FILE__) + '/spec_helper.rb'

require 'neo'

describe Trail do
  describe "creating a new trail" do
    before do
      window_options = {
        :pixel_width => 800,
        :pixel_height => 600,
        :scale => 0.15,
        :glyph_width => 128,
        :glyph_height => 128,
        :glyphs => [stub]
      }
      window_options.instance_eval do 
        self[:width] = self[:pixel_width] / (self[:glyph_width] * self[:scale])
        self[:height] = self[:pixel_height] / (self[:glyph_height] * self[:scale])
      end

      @window = stub(window_options)     
       
      window_options.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end
    
    describe "without arguments" do
      before do
        @trail = Trail.new(@window)
      end
      
      describe "should have default values" do
        it "should be going down" do
          @trail.direction.should == :down
        end
        
        it "x should be within window grid bounds" do
          (0..@width).should include(@trail.x)
        end
        
        it "y should be at the top of the window" do
          @trail.y.should == 0
        end
        
        it "should set the right movement offsets" do
          @trail.x_delta.should == 0
          @trail.y_delta.should == 1
        end
        
        it "should be green" do
          @trail.color.should == [0, 255, 0]
        end
        
        it "should set a random length" do
          (3..10).should include(@trail.length)
        end
        
        it "should set a random speed" do
          (2..8).should include(@trail.speed)
        end
        
        it "should add a glyph" do
          @trail.glyphs.size.should == 1
        end
      end
    end
    
    describe "with arguments" do
      before do
        @trail = Trail.new(
          @window,
          :length => 7,
          :speed => 4,
          :color => [0, 200, 0],
          :highlight_color => [255, 0, 0],
          :pattern => [true, false, true, true],
          :direction => :up)
      end
      
      it "set the passed through values" do
        @trail.length.should == 7
        @trail.speed.should == 4
        @trail.color.should == [0, 200, 0]
        @trail.highlight_color.should == [255, 0, 0]
        @trail.pattern.should == [true, false, true, true]
        @trail.direction.should == :up
      end
      
      it "should set the movement delta" do
        @trail.x_delta.should == 0
        @trail.y_delta.should == -1
      end
      
      describe "adding 10 glyphs" do
        before do
          10.times { @trail.add_glyph }
        end
        
        it "should not allow more than 7 opaque glyphs" do
          @trail.glyphs.reject { |g| g.fading? }.size.should == 7
        end

        it "should have the same pattern" do
          @trail.glyphs.map { |g| g.highlighted? }[0, 4].should == [true, false, true, true]
        end
        
        it "should have the other glyphs as unhighlighted" do
          @trail.glyphs[4, 8].any? { |g| g.highlighted? }.should be_false
        end
        
        it "should have 3 fading glyphs at the end" do
          @trail.glyphs[7, 3].all? { |g| g.fading? }.should be_true
        end
      end
      
      describe "drawing" do
        before do

        end
        
        it "should call draw on the glyph" do
          @glyph = mock
          @trail.glyphs = [@glyph]
          @glyph.expects(:draw)
          @glyph.expects(:visible?).returns(true)
          @trail.draw
        end
        
        it "should delete invisible glyphs" do
          @invisible_glyph = mock
          @invisible_glyph.stubs(:draw)
          @invisible_glyph.stubs(:visible?).returns(false)
          @visible_glyph = mock
          @visible_glyph.expects(:draw)
          @visible_glyph.expects(:visible?).returns(true)
          
          @trail.glyphs = [@invisible_glyph, @invisible_glyph.dup, @visible_glyph]
          @trail.draw
          @trail.glyphs.should == [@visible_glyph]
        end

      end
      
      describe "updating position" do
        before do
          @proc = proc {
            @trail.send(:set_movement_deltas)
            @trail.update_position
          }
        end
        
        describe "when going up" do
          before do
            @trail.direction = :up
          end

          it "should not touch x" do
            @proc.should change(@trail, :x).by(0)
          end
                    
          it "should decrease y" do
            @proc.should change(@trail, :y).by(-1)
          end
        end
        
        describe "when going right" do
          before do
            @trail.direction = :right
          end
          
          it "should increase x" do
            @proc.should change(@trail, :x).by(1)
          end          
          
          it "should not touch y" do
            @proc.should change(@trail, :y).by(0)
          end
        end
        
        describe "when going down" do
          before do
            @trail.direction = :down
          end
          
          it "should not touch x" do
            @proc.should change(@trail, :x).by(0)
          end          
          
          it "should increase y" do
            @proc.should change(@trail, :y).by(1)
          end
        end
        
        describe "when going left" do
          before do
            @trail.direction = :left
          end
          
          it "should decrease x" do
            @proc.should change(@trail, :x).by(-1)
          end          
          
          it "should not touch y" do
            @proc.should change(@trail, :y).by(0)
          end
        end
      end
      
    end
    
    describe "with invalid arguments" do
      it "should throw an exception when passing an invalid direction" do
        proc { Trail.new(@window, :direction => :invalid) }.should raise_error(Trail::InvalidDirection)
      end
    end
  end
end