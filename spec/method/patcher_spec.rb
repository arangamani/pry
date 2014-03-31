require_relative '../helper'

describe Pry::Method::Patcher do

  before do
    @x = Object.new
    def @x.test; :before; end
    @method = Pry::Method(@x.method(:test))
  end

  it "should change the behaviour of the method" do
    @x.test.should == :before
    @method.redefine "def @x.test; :after; end\n"
    @x.test.should == :after
  end

  it "should return a new method with new source" do
    @method.source.strip.should == "def @x.test; :before; end"
    @method.redefine("def @x.test; :after; end\n").
      source.strip.should == "def @x.test; :after; end"
  end

  it "should change the source of new Pry::Method objects" do
    @method.redefine "def @x.test; :after; end\n"
    Pry::Method(@x.method(:test)).source.strip.should == "def @x.test; :after; end"
  end

  it "should preserve visibility" do
    class << @x; private :test; end
    @method.visibility.should == :private
    @method.redefine "def @x.test; :after; end\n"
    Pry::Method(@x.method(:test)).visibility.should == :private
  end
end
