require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig do
  describe ".new" do
    it "should return a `Config` object when calling `new`" do
      described_class.new.should be_kind_of(OmniConfig::Config)
    end

    it "should forward arguments to initialize `Config`" do
      instance = described_class.new("foo")
      instance.structure.should == "foo"
    end
  end

  describe ".structure" do
    it "should return a new structure" do
      described_class.structure.should be_kind_of(OmniConfig::Structure)
    end

    it "should yield it so it can be modified" do
      yielded = nil
      result  = described_class.structure { |s| yielded = s }

      result.should eql(yielded)
    end
  end
end
