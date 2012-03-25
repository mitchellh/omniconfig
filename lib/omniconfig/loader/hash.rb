module OmniConfig
  module Loader
    # Loads configuration directly from a built-in Ruby hash.
    #
    # This loader is primarily useful for testing and setting up
    # defaults. For example, it is quite common to use the `Hash`
    # loader as the initial loader that sets defaults that can be
    # overridden by any later loaders.
    class Hash
      # Initialize a hash loader.
      #
      # @param [Hash] value The hash of settings.
      def initialize(value)
        @value = value
      end

      def load(schema)
        # We just return our hash, since that is the format the OmniConfig
        # expects us to return internally.
        return @value
      end
    end
  end
end
