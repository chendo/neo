require File.dirname(__FILE__) + '/spec_helper.rb'

require 'neo'

describe Trail do
  describe "creating a new trail" do
    describe "without arguments" do
      before do
        @window = mock(:window)
        @width = 800
        @height = 600
        @window.expects(:width).returns(@width)
        @window.expects(:height).returns(@height)
        @trail = Trail.new(@window)
      end
      
      describe "should have default values" do
        it "should be going down" do
          @trail.direction.should == 2
        end
        
        it "x should be within window bounds" do
          @trail.x.should == (0..@width)
        end
      end
    end
  end
end