require File.expand_path("../../../setup", __FILE__)
require "omniconfig"

require "support/file_helpers"

describe OmniConfig::Loader::JSONFile do
  include_context "file_helpers"

  it "should throw an error if the file doesn't exist" do
    instance = described_class.new("/tmp/i-should-never-exist-omniconfig")

    expect { instance.load(nil) }.to raise_error(OmniConfig::LoaderLoadError)
  end

  it "should parse the JSON file and return" do
    file_path = testfile("jsonfile_good.json")
    expected  = { "foo" => ["bar"] }

    instance = described_class.new(file_path)
    instance.load(nil).should == expected
  end
end

describe OmniConfig::Loader::JSONString do
  it "should parse the JSON and return it" do
    expected = { "foo" => ["bar"] }
    instance = described_class.new(%Q[{ "foo": ["bar"] }])
    instance.load(nil).should == expected
  end

  it "should throw an error if the JSON is invalid" do
    instance = described_class.new("foo")

    expect { instance.load(nil) }.to raise_error(OmniConfig::LoaderLoadError)
  end
end
