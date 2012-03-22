# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniconfig/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mitchell Hashimoto"]
  gem.email         = ["mitchell.hashimoto@gmail.com"]
  gem.description   = %q{Flexible configuration for your Ruby applications and libraries.}
  gem.summary       = %q{Flexible configuration for your Ruby applications and libraries.}
  gem.homepage      = "https://github.com/mitchellh/omniconfig"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniconfig"
  gem.require_paths = ["lib"]
  gem.version       = OmniConfig::VERSION
end
