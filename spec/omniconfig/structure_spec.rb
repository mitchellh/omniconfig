require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Structure do
  let(:instance) { described_class.new }

  it "should be able to define new members" do
    expect { instance.define("foo", "bar") }.to_not raise_error
  end
end
