module OmniConfig
  # Provides some utility methods when dealing with types in order
  # to have the proper behavior.
  class TypeUtil
    # Returns the properly typed value for the given type and value.
    # Types aren't required to implement `value` so this utility method
    # properly handles that case.
    #
    # @param [Object] type The type instance.
    # @param [Object] value The raw value.
    # @return [Object] Propertly typed value.
    def self.value(type, value)
      return value if !type.respond_to?(:value)
      type.value(value)
    end

    # Returns the old and new values properly merged for the given type.
    # This handles the case where merge may be undefined on the type.
    #
    # @param [Object] type The type instance.
    # @param [Object] old The old value.
    # @param [Object] new The new value.
    # @return [Object] The merged value
    def self.merge(type, old, new)
      return new if !type.respond_to?(:merge)
      type.merge(old, new)
    end
  end
end
