module OmniConfig
  # Represents a configuration structure for configuration, which itself
  # has many potential key/value pairs, with keys potentially mapping to
  # more structures.
  #
  # Configuration structures consist of a set of potential keys that may
  # appear in this structure. The keys in turn have their own expected
  # type and can potentially take additional options.
  #
  # While OmniConfig requires structures, it is possible to create
  # catch-all structures or keys that accept any type, which allows you to
  # break the rigidity that a structure enforces. However, if you do this,
  # you will also lose out on the nice validation and type conversion that
  # OmniConfig gives you for free. It is also possible to mix/match these
  # styles.
  #
  # An example structure is defined below:
  #
  # ```ruby
  # struct = OmniConfig::Structure.new
  # struct.define("name", OmniConfig::Type::String)
  # struct.define("age", OmniConfig::Type::Integer)
  # ```
  #
  # Note that structures alone are not useful. They are simply a means to
  # define the schema of configuration. They do not handle loading or reading
  # configuration on their own.
  class Structure
    def initialize
      @members = {}
    end

    def define(key, type)
      @members[key] = type
    end
  end
end
