require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Integer do
  let(:instance) { described_class.new }

  it "should be a type" do
    instance.should be_kind_of(OmniConfig::Type::Base)
  end

  it "returns numerics as fine" do
    instance.value(2) == 2
    instance.value(2.5) == 2
  end

  it "parses valid numeric strings" do
    instance.value("0.2") == 0
    instance.value("2") == 2
    instance.value("2.2") == 2
    instance.value(".25") == 0
  end

  ["BAD", Object.new, "...5"].each do |value|
    it "raises a type error for invalid: #{value}" do
      expect { instance.value(value) }.to raise_error(OmniConfig::TypeError)
    end
  end
end
