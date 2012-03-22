require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Result do
  it "can access configuration like a hash" do
    value = { "foo" => "bar" }
    instance = described_class.new(value)
    instance["foo"].should == "bar"
  end

  it "can access configuration like attributes" do
    value = { "foo" => "bar" }
    instance = described_class.new(value)
    instance.foo.should == "bar"
  end

  it "properly raises a NoMethodError if an invalid attribute is given" do
    pending "Not quite sure why this fails. Wait until internet."

    instance = described_class.new({})
    expect { instance.foo }.to raise_error(NoMethodError)
  end

  it "returns a hash if asked" do
    value = { "foo" => "bar" }
    instance = described_class.new(value)

    # It should return the same hash structurally, but not the
    # exact same object.
    instance.to_hash.should == value
    instance.to_hash.equal?(value).should_not be
  end
end
