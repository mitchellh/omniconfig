require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Loader::Hash do
  it "should return the given hash as its load result" do
    value = { :foo => :bar, "baz" => "bacon" }
    instance = described_class.new(value)
    instance.load.should == value
  end
end
