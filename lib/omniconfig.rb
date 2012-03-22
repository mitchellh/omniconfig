require "omniconfig/version"

module OmniConfig
  autoload :Config,    'omniconfig/config'
  autoload :Structure, 'omniconfig/structure'

  module Type
    autoload :String, 'omniconfig/type/string'
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
end
