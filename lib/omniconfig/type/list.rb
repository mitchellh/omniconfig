module OmniConfig
  module Type
    # A list of elements of a specific type.
    class List < Base
      # Initializes a list type where the elements will be of the given
      # type.
      #
      # @param [Object] type The type of the elements.
      def initialize(type)
        @type = TypeUtil.instance(type)
      end

      def value(raw)
        raise TypeError if !raw.is_a?(Array)

        # Map over the array and convert each item to the proper type
        raw.map do |raw_item|
          TypeUtil.value(@type, raw_item)
        end
      end
    end
  end
end
