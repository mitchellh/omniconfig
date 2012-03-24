module OmniConfig
  module Type
    # Base class for all types. Types must inherit from this class,
    # as the inheritance is checked when {Structure#define} is being
    # called.
    class Base
      # By default a type will simply return the raw value as the
      # converted result.
      def value(raw)
        raw
      end

      # By default merging types results in the new type being used.
      def merge(old, new)
        new
      end
    end
  end
end
