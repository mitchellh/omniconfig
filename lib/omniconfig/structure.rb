require "omniconfig/type/base"

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
  # struct = OmniConfig.structure({
  #   "name" => OmniConfig::Type::String,
  #   "age"  => OmniConfig::Type::Integer
  # })
  # ```
  #
  # Note that structures alone are not useful. They are simply a means to
  # define the schema of configuration. They do not handle loading or reading
  # configuration on their own.
  class Structure < Type::Base
    # The members that have been defined on this structure. DO NOT modify this
    # hash in place under any circumstances.
    attr_reader :members

    # Create a new structure. The shortcut {OmniConfig.structure} should be
    # used instead.
    #
    # @param [Hash] structure The structure to build where key is the key to
    #   define and value is the type. You can also always call {#define}.
    # @param [Hash] opts Arbitrary options for this structure as a type. These
    #   have no effect unless a loader uses them in some way.
    def initialize(structure=nil, opts=nil)
      super(opts)

      @members = {}

      # A hash structure can optionally be specified as a shortcut to
      # define a structure.
      if structure
        structure.each do |key, value|
          define(key, value)
        end
      end

      # If a block was given, then we yield with ourselves
      yield self if block_given?
    end

    # Define a new member on this structure. If the member was previously
    # defined then it will be overridden here.
    #
    # @param [String] key Key of the configuration
    # @param [Object] type The type. This can either be a class or an instantiated
    #   object.
    def define(key, type)
      # Verify the type is correct
      Util.require_type!(type)

      # Set it, overriding any previously potentially set member
      @members[key.to_s] = type.instance
    end

    # Converts a raw input into this structure. This is the method that
    # allows any arbitrary structure to be a configuration type as well,
    # so you can enforce that certain keys are of a certain structure:
    #
    # ```ruby
    # person = Structure.new("name" => String)
    # family = Structure.new("father" => person, "mother" => person)
    # ```
    #
    # @param [Hash] raw
    # @return [Hash]
    def value(raw)
      raise TypeError if !raw.is_a?(Hash)

      # Build up the result with only valid members, converting the types
      # properly as we go.
      result = {}
      @members.each do |key, type|
        if raw.has_key?(key)
          result[key] = type.value(raw[key])
        else
          # Every member of the struct should be present in the resulting value
          result[key] = UNSET_VALUE
        end
      end

      result
    end

    # Merge behavior for structures used as a type. This generally shouldn't
    # be called by the general public.
    #
    # The merge behavior for a structure is to do a deep merge, merging each
    # individual field within.
    def merge(old, new)
      # We don't need to merge if one of the values is unset, since that is
      # pretty straightforward.
      return new if old == UNSET_VALUE
      return old if new == UNSET_VALUE

      # Merge member by member
      result = {}
      @members.each do |key, type|
        if old.has_key?(key) && !new.has_key?(key)
          result[key] = old[key]
        elsif !old.has_key?(key) && new.has_key?(key)
          result[key] = new[key]
        elsif old.has_key?(key) && new.has_key?(key)
          # If the new value is UNSET, then we don't do anything.
          if new[key] != UNSET_VALUE
            result[key] = type.merge(old[key], new[key])
          else
            result[key] = old[key]
          end
        end
      end

      result
    end
  end
end
