module OmniConfig
  module Type
    # Base class for all types. Types must inherit from this class,
    # as the inheritance is checked when {Structure#define} is being
    # called.
    class Base
      # Every type can have arbitrary options added to it that the loaders
      # might use for some reason. This is the options hash that can be used
      # to add or modify options.
      attr_reader :options

      # Initializes the type and returns an instance of it.
      #
      # @return [Object] Instantiated type.
      def self.instance
        self.new
      end

      # Initialize a type, passing in the given options as options to the
      # type.
      def initialize(opts=nil)
        @options    = opts || {}
        @validators = []
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

      # By default a type will simply return the raw value as the
      # converted result.
      def value(raw)
        raw
      end

      # By default merging types results in the new type being used.
      def merge(old, new)
        new
      end

      # Validate a value.
      #
      # @param [ErrorRecorder] errors Error recorder that any validation errors
      #   should be added to.
      # @param [Object] value The value to validate. This is guaranteed to
      #   be some value returned by {#value} on this type.
      def validate(errors, value)
        # Call the validators in order passing in the error recorder
        # and value.
        @validators.each { |v| v.call(errors, value) }
      end

      # Adds a validator to this type. The validators are called for
      # each type and are passed the value that they return from {#value}.
      # There are two options for creating a validator: you can pass it an
      # object that responds to `validate` or you may pass it a block. Both
      # the validate method and the block must take two parameters. See the
      # documentation of the parameters below for more information.
      #
      # @param [Object] validator An object that responds to `validate`. It
      #   takes the same parameters as the block.
      # @yield [errors, value] Called to validate. This will add to the `errors`
      #   parameter if there are errors.
      # @yieldparam [ErrorRecorder] Error recorder that errors should be added to.
      # @yieldparam [Object] value The value returned by {#value} of this type.
      def add_validator(validator=nil, &block)
        # Only one of these may be specified
        if validator && block
          raise ArgumentError, "Only a validator _or_ a block may be specified."
        end

        # This will keep track of the callable for validation
        callable = nil

        if validator
          # Validator objects must respond to validate
          if !validator.respond_to?(:validate)
            raise ArgumentError, "Validator object must respond to `validate`"
          end

          # The callable is just to call the validate method
          callable = validator.method(:validate)
        else
          # The callable is just the block itself
          callable = block
        end

        # Add the callable to the validators list
        @validators << callable
      end
    end
  end
end
