require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Base do
  let(:instance) { described_class.new }

  it "should just let values pass through" do
    value = Object.new
    instance.value(value).should eql(value)
  end

  it "should use the newest value for a merge" do
    old = Object.new
    new = Object.new
    instance.merge(old, new).should eql(new)
  end
end
