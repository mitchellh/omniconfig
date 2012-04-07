require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Bool do
  let(:instance) { described_class.new }

  it "should be a type" do
    instance.should be_kind_of(OmniConfig::Type::Base)
  end

  it "should return a proper boolean" do
    instance.value("7").should == true
    instance.value(nil).should == false
  end
end
