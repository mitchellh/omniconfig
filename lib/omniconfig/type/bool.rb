module OmniConfig
  module Type
    # Boolean type for members of {Structure} classes.
    #
    # The Boolean type uses Ruby's notion of truthiness, for now.
    class Bool < Base
      def value(value)
        # Just convert the thing to a bool.
        !!value
      end
    end
  end
end
