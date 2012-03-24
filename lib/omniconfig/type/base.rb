module OmniConfig
  module Type
    # Base class for all types. Types must inherit from this class,
    # as the inheritance is checked when {Structure#define} is being
    # called.
    class Base
      # Initializes the type and returns an instance of it.
      #
      # @return [Object] Instantiated type.
      def self.instance
        self.new
      end

      # This just returns this instance. This is useful because there is also
      # a class method {instance} which can be called which will initialize the
      # class and return a new instance. Therefore, you can just call `instance`
      # on any type and feel safe that you'll get an instance of it back.
      #
      # @return [Object] self
      def instance
        self
      end

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
