# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniconfig/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mitchell Hashimoto"]
  gem.email         = ["mitchell.hashimoto@gmail.com"]
  gem.description   = %q{Flexible configuration for your Ruby applications and libraries.}
  gem.summary       = %q{Flexible configuration for your Ruby applications and libraries.}
  gem.homepage      = "https://github.com/mitchellh/omniconfig"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "redcarpet", "~> 2.1.0"
  gem.add_development_dependency "rspec-core", "~> 2.8.0"
  gem.add_development_dependency "rspec-expectations", "~> 2.8.0"
  gem.add_development_dependency "rspec-mocks", "~> 2.8.0"
  gem.add_development_dependency "yard", "~> 0.7.5"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniconfig"
  gem.require_paths = ["lib"]
  gem.version       = OmniConfig::VERSION
end
