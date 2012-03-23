require "omniconfig/errors"
require "omniconfig/version"

module OmniConfig
  # This is a unique object that represents a value was not set for
  # a given configuration key. Since `nil` may be the desired value to
  # set for an option, this should be the flag to verify if it is truly
  # unset.
  UNSET_VALUE = Object.new

  autoload :Config,    'omniconfig/config'
  autoload :Structure, 'omniconfig/structure'
  autoload :TypeUtil,  'omniconfig/type_util'

  module Loader
    autoload :Hash,    'omniconfig/loader/hash'
  end

  module Type
    autoload :Any,     'omniconfig/type/any'
    autoload :Integer, 'omniconfig/type/integer'
    autoload :List,    'omniconfig/type/list'
    autoload :String,  'omniconfig/type/string'
  end

  # This is a shorcut for initializing a {Config} object. This is provided
  # because typing `OmniConfig::Config` is a bit redundant. The namespacing
  # was done this way since it leads to a better overall organized internal
  # structure, and this API is to provider the cleaner API to decisions for
  # internal strucutre.
  #
  # @return [Config]
  def self.new(*args)
    Config.new(*args)
  end

  # This is a shortcut for initializing a {Structure} object. If a block is
  # given, the new structure will be yielded to it, so you can modify it
  # in place. Finally, the new structure will be returned.
  #
  # @return [Structure]
  def self.structure
    result = Structure.new
    yield result if block_given?
    result
  end
end
