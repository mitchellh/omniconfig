require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::List do
  let(:instance) { described_class.new(type) }
  let(:type) do
    Class.new(OmniConfig::Type::Base) do
      def value(raw)
        raw.to_s
      end
    end
  end

  it "should be a type" do
    instance.should be_kind_of(OmniConfig::Type::Base)
  end

  it "raises an error if the raw value is not an array" do
    expect { instance.value("FOO") }.to raise_error(OmniConfig::TypeError)
  end

  it "attempts to convert to array using `to_a` if it can" do
    instance.value(1..5).should == %W[1 2 3 4 5]
  end

  it "raises an error if to_a still doesn't convert to an Array" do
    klass = Class.new do
      def to_a; "FOO"; end
    end

    expect { instance.value(klass.new) }.to raise_error(OmniConfig::TypeError)
  end

  it "converts each item to the proper type" do
    raw      = [1, 1.2, "foo"]
    expected = ["1", "1.2", "foo"]

    instance.value(raw).should == expected
  end
end
