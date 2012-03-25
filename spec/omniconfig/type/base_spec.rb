require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Base do
  let(:instance) { described_class.new }

  it "should set options from initialization" do
    instance = described_class.new(:foo => :bar)
    instance.options[:foo].should == :bar
  end

  it "should just let values pass through" do
    value = Object.new
    instance.value(value).should eql(value)
  end

  it "should use the newest value for a merge" do
    old = Object.new
    new = Object.new
    instance.merge(old, new).should eql(new)
  end

  it "should allow options to be set" do
    instance.options.should be_kind_of(Hash)
    instance.options["foo"] = "bar"
    instance.options["foo"].should == "bar"
  end
end
