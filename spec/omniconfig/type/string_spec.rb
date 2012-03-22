require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::String do
  let(:instance) { described_class.new }

  it "should convert the value to a string" do
    instance.parse(7).should == "7"
    instance.parse("result").should == "result"
  end

  it "should keep nil a nil" do
    instance.parse(nil).should == nil
  end
end
