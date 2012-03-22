# OmniConfig

Omniconfig is a Ruby configuration library that allows Ruby libraries
and applications to be configured by _anything_. For web applications,
this may be useful as service configuration can come from a central
source such as ZooKeeper. For command line applications, this is useful
because the application configuration itself can potentially be in
any format: Ruby, Python, XML, etc.

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
person = OmniConfig::Structure.new
person.define("name", OmniConfig::Types::String)
person.define("age", OmniConfig::Types::Integer)

root = OmniConfig;:Structure.new
root.define("manager", OmniConfig::Types::String)
root.define("employees", OmniConfig::Types::List, person)
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
config = OmniConfig.new
config.set_structure(root)
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
settings = config.load!

# Use it
puts "The manager is: #{settings.manager}"
puts "Employees count: #{settings.employees.length}"
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
