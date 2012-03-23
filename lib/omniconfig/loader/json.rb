module OmniConfig
  module Loader
    # This loader loads configuration from a JSON file. This class
    # is identical to {JSONString} except that a file path is passed
    # to the constructor instead of raw JSON.
    class JSONFile
      # Initializes the JSON file loader, which will load and parse the
      # given JSON file.
      def initialize(path)
        @path = path
      end

      def load
        if !File.file?(@path)
          raise LoaderLoadError, "JSON file doesn't exist: #{@path}"
        end

        # Just read the file, and load as a JSON string
        return JSONString.new(File.read(@path)).load
      end
    end

    # This loader loads configuration from JSON which is passed in
    # as a string to initialize the loader.
    #
    # The JSON structure is basically just parsed and sent as-is
    # to the underlying OmniConfig internals. Therefore, the translation
    # to OmniConfig structures is very clear. Given the following
    # example schema:
    #
    # ```ruby
    # schema = OmniConfig.structure({
    #   "name" => String,
    #   "contact_info" => List.new(OmniConfig.structure({
    #     "type"  => String,
    #     "value" => String
    #   }))
    # })
    # ```
    #
    # The following is valid JSON matching this:
    #
    # ```javascript
    # {
    #   "name": "Mitchell Hashimoto",
    #   "contact_info" => [
    #     { "type" => "phone", "value" => "555-1234" },
    #     { "type" => "email", "value" => "foo.bar@gmail.com" }
    #   ]
    # }
    # ```
    class JSONString
      # Initializes the JSONString loader, which will parse the given
      # raw JSON string given as input.
      def initialize(raw)
        @raw = raw
      end

      def load
        # Load the JSON parser
        begin
          require 'json'
        rescue LoadError => e
          raise LoaderDependencyError, "'json' gem required for JSON loading."
        end

        begin
          # Parse our raw data and return it
          return JSON.parse(@raw)
        rescue JSON::ParserError => e
          raise LoaderLoadError, "Failed to parse JSON: #{e}"
        end
      end
    end
  end
end
