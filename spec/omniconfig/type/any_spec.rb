require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Any do
  let(:instance) { described_class.new }

  it "should just let values pass through" do
    value = Object.new
    instance.value(value).should eql(value)
  end
end
