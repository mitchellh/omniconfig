module OmniConfig
  module Type
    # Base class for all types. Types must inherit from this class,
    # as the inheritance is checked when {Structure#define} is being
    # called.
    class Base
      # Every type can have arbitrary options added to it that the loaders
      # might use for some reason. This is the options hash that can be used
      # to add or modify options.
      #
      # @return [Hash]
      def options
        @options ||= {}
      end

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
