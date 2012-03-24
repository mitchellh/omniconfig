module OmniConfig
  module Type
    # String type for members of {Structure} classes.
    #
    # This class verifies that the configuration parameter is properly
    # converted to a string value.
    class String < Base
      def value(value)
        # `nil` should remain a nil
        return nil if value.nil?

        # Just convert the thing to a string.
        value.to_s
      end
    end
  end
end
