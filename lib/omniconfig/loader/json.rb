module OmniConfig
  module Loader
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

        # Parse our raw data and return it
        # XXX: Error handling
        JSON.parse(@raw)
      end
    end
  end
end
