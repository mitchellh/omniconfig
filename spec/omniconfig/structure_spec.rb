require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Structure do
  let(:instance) { described_class.new }

  it "should be able to define new members" do
    expect { instance.define("foo", "bar") }.to_not raise_error

    instance.members.should have_key("foo")
    instance.members["foo"].should == "bar"
  end
end
