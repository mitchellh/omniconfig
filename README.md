# OmniConfig

[![Build Status](https://secure.travis-ci.org/mitchellh/omniconfig.png?branch=master)](http://travis-ci.org/mitchellh/omniconfig)

OmniConfig is a Ruby library that provides flexible configuration for your
applications or libraries. The key idea behind OmniConfig is the separation
of configuration definition and configuration loading. This allows you to
define your available configuration values, and have that configuration
loaded from anywhere, such as JSON files, Ruby structures, a remote server
(like ZooKeeper), etc.

## Installation

Omniconfig is distributed as a gem. Any software that wants to be configured
with omniconfig will require this gem:

    $ gem install omniconfig

## Usage

OmniConfig is a schema-based configuration library. This allows OmniConfig
to validate structure and types of incoming configuration values. Of course,
embracing the dynamic nature of Ruby, it is perfectly possible to accept any
values and do decoding yourself, if you wish. However, most applications have
a finite set of configuration parameters.

Defining a schema for your configuration is easy:

```ruby
# This lets us drop the namespace for the types, not necessary but helpful
include OmniConfig::Type

person = OmniConfig.structure({
  "name" => String,
  "age"  => Integer
})

root = OmniConfig.structure({
  "manager"   => String,
  "employees" => List.new(person)
})
```

The easiest way to show what the above schema looks like is using JSON.
Note that if you choose to support JSON as a configuration language, then
this actually works!

```json
{
  "manager": "Mitchell Hashimoto",
  "employees": [
    { "name": "John", "age": "42" },
    { "name": "Tim", "age": "24" },
    { "name": "Amy", "age": "32" }
  ]
}
```

Once your schema is defined, you need to create an `OmniConfig` object,
tell it of your schema, and assign a set of loaders to it which know
how to load actual configuration from specific sources:

```ruby
config = OmniConfig.new(root)
config.add_loader(OmniConfig::Loader::JSON.new("config.json"))
config.add_loader(OmniConfig::Loader::Ruby.new("config.rb"))
config.add_loader(OmniConfig::Loader::CommandLine.new)
```

This tells OmniConfig for the `config` instance to accept the structure
`root` (which we defined above), and to load from a set of sources. Note
that sources added later will override those set earlier (so any conflicting
configuration found when reading Ruby will override that of the JSON, for
example).

Finally, load it, and use your new configuration:

```
settings = config.load

# Use it
puts "The manager is: #{settings["manager"]}"
puts "Employees count: #{settings["employees"].length}"
```

Amazing! The true power in this approach is that there is a distinct separation
between available configuration settings and the loading of these settings,
allowing the loading to come from many sources.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
