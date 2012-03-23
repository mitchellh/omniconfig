require "pathname"

shared_context "file_helpers" do
  # This returns the path to the testfile of the given name.
  #
  # @return [Pathname]
  def testfile(path)
    Pathname.new(File.expand_path("../test_files/#{path}", __FILE__))
  end
end
