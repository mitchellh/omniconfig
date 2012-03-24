require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Util do
  let(:type)     { Class.new(OmniConfig::Type::Base) }
  let(:type_instance) { type.new }

  describe "require_type!" do
    it "should raise an exception if an invalid type is given" do
      expect { described_class.require_type!("foo") }.
        to raise_error(ArgumentError)
    end

    it "should do nothing if the type is a valid type class" do
      expect { described_class.require_type!(type) }.
        to_not raise_error
    end

    it "should do nothing if the type is a valid type instance" do
      expect { described_class.require_type!(type_instance) }.
        to_not raise_error
    end
  end
end
