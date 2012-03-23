module OmniConfig
  # The result set of loading settings.
  #
  # This is not quite a hash but provides access mechanisms just like
  # a Hash does. You can call {#to_hash} at anytime to turn this into
  # a hash.
  #
  # In addition to accessing results like a Hash, you can simply access
  # them as if they were attributes on this class. For example, if your
  # schema defined a `name` configuration, then you can do `result.name`
  # to get the name.
  class Result
    # Initializes a resuult object with a hash.
    #
    # @param [Hash] settings The settings hash to use.
    def initialize(settings)
      # We clone the settings so that if the caller modifies them later,
      # it doesn't adversely affect us.
      @settings = settings.clone
    end

    # Hash-style access to return configuration parameters.
    def [](key)
      @settings[key]
    end

    # Method missing magic is used to get the accessor-like API to this
    # class.
    def method_missing(name, *args, &block)
      # We only deal with string names
      key = name.to_s

      # Return the setting if we have it
      return @settings[key] if @settings.has_key?(key)

      # Otherwise let inheritance deal with it
      super
    end

    # Returns this result set converted to a native Ruby Hash object.
    #
    # @return [Hash]
    def to_hash
      @settings.clone
    end
  end
end
