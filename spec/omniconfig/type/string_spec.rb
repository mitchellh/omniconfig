require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::String do
  let(:instance) { described_class.new }

  it "should be a type" do
    instance.should be_kind_of(OmniConfig::Type::Base)
  end

  it "should convert the value to a string" do
    instance.value(7).should == "7"
    instance.value("result").should == "result"
  end

  it "should keep nil a nil" do
    instance.value(nil).should == nil
  end
end
