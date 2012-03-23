require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Loader::JSONString do
  it "should parse the JSON and return it" do
    expected = { "foo" => ["bar"] }
    instance = described_class.new(%Q[{ "foo": ["bar"] }])
    instance.load.should == expected
  end
end
