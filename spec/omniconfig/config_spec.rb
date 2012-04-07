require File.expand_path("../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Config do
  let(:instance) { described_class.new(structure) }
  let(:structure) { OmniConfig::Structure.new }

  let(:smallest_number_type) {
    Class.new(OmniConfig::Type::Base) do
      def merge(old, new)
        [old, new].min
      end
    end
  }

  let(:positive_type) {
    Class.new(OmniConfig::Type::Base) do
      def validate(errors, value)
        errors.add("Must be positive!") if value < 0
      end
    end
  }

  it "should load basic values" do
    config = { "key" => "value" }
    structure.define("key", OmniConfig::Type::String)
    instance.add_loader(OmniConfig::Loader::Hash.new(config))

    result = instance.load
    result["key"].should == "value"
  end

  it "should mark settings as UNSET if they aren't set" do
    structure.define("key", OmniConfig::Type::String)
    instance.add_loader(OmniConfig::Loader::Hash.new({}))

    result = instance.load
    result["key"].should eql(OmniConfig::UNSET_VALUE)
   end

  it "should prefer values loaded later by default" do
    structure.define("key", OmniConfig::Type::String)
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => "foo" }))
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => "bar" }))

    result = instance.load
    result["key"].should == "bar"
  end

  it "should merge values" do
    structure.define("key", smallest_number_type)
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => 3 }))
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => 2 }))
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => 5 }))

    result = instance.load
    result["key"].should == 2
  end

  it "should throw an exception if a loader doesn't properly return a Hash" do
    bad_loader = Class.new do
      def load(schema)
        nil
      end
    end

    instance.add_loader(bad_loader.new)
    expect { instance.load }.to raise_error(OmniConfig::LoaderLoadError)
  end

  it "should throw an exception if there is a validation error" do
    structure.define("key", positive_type)
    instance.add_loader(OmniConfig::Loader::Hash.new({ "key" => -7 }))

    expect { instance.load }.to raise_error { |error|
      error.should be_kind_of(OmniConfig::InvalidConfiguration)
      error.settings["key"].should == -7
      error.errors.should == ["Must be positive!"]
    }
  end

  it "should support wrapping results" do
    klass = Class.new do
      attr_reader :original

      def initialize(original)
        @original = original
      end

      def wrapped?; true; end
    end

    structure.define("key", OmniConfig::Type::Any)
    instance = described_class.new(structure, :result_class => klass)
    instance.add_loader(OmniConfig::Loader::Hash.new("key" => 10))

    result   = instance.load
    result.original.should == { "key" => 10 }
    result.should be_kind_of(klass)
    result.should be_wrapped
  end
end
