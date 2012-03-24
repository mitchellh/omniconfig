module OmniConfig
  module Type
    # This type just returns the raw value as-is and does no
    # type-checking.
    #
    # This allows you to do your own decoding and type checking,
    # if it pleases you.
    class Any < Base
      # Default implementation works fine.
    end
  end
end
