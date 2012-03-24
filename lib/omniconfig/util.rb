module OmniConfig
  class Util
    # This utility method raises an exception if type is not a proper
    # type object.
    def self.require_type!(type)
      type_class = false
      type_class = true if type.is_a?(Class) && type <= Type::Base
      type_class = true if type.is_a?(Type::Base)
      raise ArgumentError, "type must be a Type::Base object." if !type_class
    end
  end
end
