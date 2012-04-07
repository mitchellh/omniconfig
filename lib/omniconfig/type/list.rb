module OmniConfig
  module Type
    # A list of elements of a specific type.
    class List < Base
      # Initializes a list type where the elements will be of the given
      # type.
      #
      # @param [Object] type The type of the elements.
      def initialize(type)
        super()

        Util.require_type!(type)

        @type = type.instance
      end

      def value(raw)
        if !raw.is_a?(Array)
          raw = raw.to_a if raw.respond_to?(:to_a)
          raise TypeError if !raw.is_a?(Array)
        end

        # Map over the array and convert each item to the proper type
        raw.map do |raw_item|
          @type.value(raw_item)
        end
      end
    end
  end
end
