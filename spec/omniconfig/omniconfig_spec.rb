require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig do
  it "should return a `Config` object when calling `new`" do
    described_class.new.should be_kind_of(OmniConfig::Config)
  end

  it "should forward arguments to initialize `Config`" do
    instance = described_class.new("foo")
    instance.structure.should == "foo"
  end
end
