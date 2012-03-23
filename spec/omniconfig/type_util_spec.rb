require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::TypeUtil do
  describe "instance" do
    it "should return the instance given if given" do
      described_class.instance("foo").should == "foo"
    end

    it "should instantiate a class if given" do
      type = Class.new
      described_class.instance(type).should be_kind_of(type)
    end
  end

  describe "value" do
    it "should return the raw value if the type doesn't respond to value" do
      described_class.value("FOO", "value").should == "value"
    end

    it "should call `value` if it responds to it" do
      type = Class.new do
        def value(raw)
          42
        end
      end

      described_class.value(type.new, "value").should == 42
    end
  end

  describe "merge" do
    it "should just return the newer value if type doesn't respond to merge" do
      described_class.merge("FOO", "old", "new").should == "new"
    end

    it "should call `merge` if the type supports it" do
      type = Class.new do
        def merge(old, new)
          42
        end
      end

      described_class.merge(type.new, "old", "new").should == 42
    end
  end
end
