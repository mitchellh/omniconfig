require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Structure do
  let(:instance) { described_class.new }
  let(:type)     { Class.new(OmniConfig::Type::Base) }
  let(:type_instance) { type.new }

  it "should be able to define members using a hash to initialize" do
    instance = described_class.new("foo" => type_instance)
    instance.members["foo"].should == type_instance
  end

  it "should be able to define new members" do
    expect { instance.define("foo", type_instance) }.to_not raise_error

    instance.members.should have_key("foo")
    instance.members["foo"].should == type_instance
  end

  it "should raise an error if a schema member type isn't a type" do
    expect { instance.define(:foo, "bar") }.to raise_error(ArgumentError)
  end

  it "should force all member keys to be strings" do
    instance.define(:foo, type_instance)
    instance.members.should_not have_key(:foo)
    instance.members["foo"].should == type_instance
  end

  describe "value parsing" do
    it "should raise a TypeError if not a hash" do
      expect { instance.value(7) }.to raise_error(OmniConfig::TypeError)
    end

    it "should work with a valid structure" do
      instance.define("foo", OmniConfig::Type::Any)
      instance.define("bar", OmniConfig::Type::Any)

      original = { "foo" => 1, "bar" => "2", "baz" => 3 }
      expected = { "foo" => 1, "bar" => "2" }
      instance.value(original).should == expected
    end
  end

  describe "value merging" do
    it "should merge properly" do
      instance.define("foo", OmniConfig::Type::Any)
      instance.define("bar", OmniConfig::Type::Any)
      instance.define("baz", OmniConfig::Type::Any)

      old = { "foo" => 5, "baz" => 15 }
      new = { "bar" => 10, "baz" => 20 }
      result = instance.merge(old, new)
      result["foo"].should == 5
      result["bar"].should == 10
      result["baz"].should == 20
    end
  end
end
