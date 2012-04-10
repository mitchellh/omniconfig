require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

describe OmniConfig::Type::Base do
  let(:instance) { described_class.new }

  it "should set options from initialization" do
    instance = described_class.new(:foo => :bar)
    instance.options[:foo].should == :bar
  end

  it "should use UNSET_VALUE as a default" do
    instance.default.should == OmniConfig::UNSET_VALUE
  end

  it "should just let values pass through" do
    value = Object.new
    instance.value(value).should eql(value)
  end

  it "should use the newest value for a merge" do
    old = Object.new
    new = Object.new
    instance.merge(old, new).should eql(new)
  end

  it "should allow options to be set" do
    instance.options.should be_kind_of(Hash)
    instance.options["foo"] = "bar"
    instance.options["foo"].should == "bar"
  end

  describe "validations" do
    it "should raise an error if both a validator and a block are given" do
      expect { instance.add_validator(5) { |block| } }.
        to raise_error(ArgumentError)
    end

    it "should error if the validator doesn't validate properly" do
      validator = Object.new
      expect { instance.add_validator(validator) }.
        to raise_error(ArgumentError)
    end

    it "should add a validator instance" do
      klass = Class.new do
        def validate; end
      end

      instance.add_validator(klass.new)
    end

    it "should add a validator block" do
      instance.add_validator { |recorder, errors| }
    end

    it "should call the validators in order" do
      klass = Class.new do
        def validate(errors, value)
          value << "A"
        end
      end

      instance.add_validator(klass.new)
      instance.add_validator { |_, value| value << "B" }
      instance.add_validator { |_, value| value << "C" }

      result = []
      instance.validate(nil, result)

      result.should == ["A", "B", "C"]
    end
  end
end
