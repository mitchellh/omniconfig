require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig do
  let(:type) { Class.new(OmniConfig::Type::Base) }
  let(:type_instance) { type.new }

  describe ".new" do
    it "should return a `Config` object when calling `new`" do
      described_class.new.should be_kind_of(OmniConfig::Config)
    end

    it "should forward arguments to initialize `Config`" do
      instance = described_class.new("foo")
      instance.schema.should == "foo"
    end
  end

  describe ".structure" do
    it "should return a new structure" do
      described_class.structure.should be_kind_of(OmniConfig::Structure)
    end

    it "should forward args to the structure" do
      struct = described_class.structure("foo" => type_instance)
      struct.should be_kind_of(OmniConfig::Structure)
      struct.members["foo"].should == type_instance
    end

    it "should yield it so it can be modified" do
      yielded = nil
      result  = described_class.structure { |s| yielded = s }

      result.should eql(yielded)
    end
  end
end
