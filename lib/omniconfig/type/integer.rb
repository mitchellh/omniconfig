module OmniConfig
  module Type
    # Integer type for structure members.
    #
    # This will raise a typeerror unless the value appears numeric.
    # Ruby's "to_i" conversion is a bit too flexible ("foo".to_i => 0),
    # so this does a basic Regex check on any strings passed in to verify
    # they're numeric in some way.
    class Integer
      def value(raw)
        # If the value is numeric, we just convert to an integer, Ruby
        # does the right thing here.
        return raw.to_i if raw.is_a?(Numeric)

        # Otherwise, we first convert to a string, then attempt to convert
        # that string back to a integer.
        raw = raw.to_s
        raise TypeError, "Cannot parse integer: #{raw}" if raw !~ /^[0-9]?\.?[0-9]+$/
        raw.to_i
      end
    end
  end
end
