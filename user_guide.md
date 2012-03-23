# OmniConfig User Guide

OmniConfig is a Ruby library that provides flexible configuration for your
applications or libraries. The key idea behind OmniConfig is the separation
of configuration definition and configuration loading. This allows you to
define your available configuration values, and have that configuration
loaded from anywhere, such as JSON files, Ruby structures, a remote server
(like ZooKeeper), etc.

## Installation

OmniConfig is distributed as a RubyGem, so simply gem install. OmniConfig
should become a dependency for whatever application or library you're
installing.

```console
gem install omniconfig
```

## Getting Started

Before diving into the details, let's go through a quick example that showcases
the basic features and overall feel of the library. This should let you
get an idea of how it works.

### Define Your Schema

The first thing you must do in your OmniConfig-powered application is to
define the schema of your configuration. Defining a schema beforehand allows
OmniConfig to verify your configuration structure and to do basic validation.
Most applicaitons have a rigid configuration schema so this is not an issue.
If your application allows arbitrary configuration options, then OmniConfig
supports this as well, and is covered later in this guide. Below is an
example schema for a hypothetical proxy:

```ruby
# This puts all the types that OmniConfig supports in the top-level,
# to get rid of a lot of redundant namespacing
include OmniConfig::Type

vhost = OmniConfig.structure({
  "domain"   => String,
  "backends" => List.new(String)
})

root = OmniConfig.structure({
  "vhosts" => List.new(vhost)
})
```

The above defines a the structure of the configuration file. The important
one is the one we assigned to `root`, which represents the top-level structure.
As you can see, the `root` has one available key which is `vhosts` that is
going to be a list of the `vhost` structures. A `vhost` has a `domain` and
a list of string `backends`.

To perhaps make the schema a bit clearer, if we were configuring our
application with JSON, a valid configuration that matches the above schema
would look like this:

```javascript
{
  "vhosts": [
    { "domain" => "google.com", "backends" => ["1.2.3.4", "2.3.4.5"] },
    { "domain" => "kiip.me", "backends" => ["3.4.5.6"] }
  ]
}
```

Okay, so at this point, we know exactly the _structure_ and _data_ we want
out of our configuration, but we haven't done anything that can actually
read this configuration. This is good, because it means that loading can
always be changed later without affecting our schema, and vice versa.

### Add Some Loaders

Now that we have our schema, we create an `OmniConfig` object for the
root schema, and add some loaders. Loaders are -- if you haven't guessed
already -- responsible for loading configuration into our schema.
Assuming we're building on the example above, here is the next step:

```ruby
# Just like above, we're going to just include this namespace to make
# the example clearer.
include OmniConfig::Loader

config = OmniConfig.new(root)
config.add_loader(JSONFile("config.json"))
config.add_loader(CommandLine)
```

This creates an `OmniConfig` object, an object which knows both about
the structure of our configuration as well as how we want to load it,
and therefore has the responsibility of loading our final config. On
this object we added a couple loaders. First, we added a `JSONFile`
loader which will load our configuration from a JSON file. Then, we
added a `CommandLine` loader that will allow us to override any of the
JSON configuration on the command line. The order the loaders are
added determines the precedence of the configuration set via that
loader.

### Load!

Now that we have the `OmniConfig` object setup with loaders and a
schema, loading the configuration and using it is trivial:

```ruby
result = config.load

puts "We're configuring #{result["vhosts"].length} vhosts:"

result["vhosts"].each do |vhost|
  puts "Domain: #{vhost["domain"]}"

  vhost["backends"].each do |backend|
    puts "  - Backend: #{backend}"
  end
end
```

_Whoa!_ Cool, isn't it? Now, if we wanted to support something like
ZooKeeper, for example, we can just slide that loader into place
and it'll all _just work_. Incredibly powerful.

You can do much more with OmniConfig, such as validation, defining
your own types, and defining your own loaders. For more on this,
read on!

## Types

This section lists all the built-in types in OmniConfig as well as documenting
how you can make your own custom types.

Types are responsible for converting values to specific Ruby types, and also
verifying that these values are valid. For example, if you ask for a `Float`
type and it is configured with the value `google.com`, then this is obviously
invalid, and the type is responsible for raising an exception in this case.

### {OmniConfig::Type::String String}

Returns the string version of any value. The only value that will not be
changed is `nil`, which will remain `nil`.

### Custom

Building a custom type is easy. Types are basic Ruby classes that can
implement any of the following methods:

* `value(raw)` - This is given the raw value from the loader and is
  expected to return a value of the proper Ruby type, or to raise an
  exception in the case that it could not be converted.
* `merge(old, new)` - This is called when there is a configuration
  conflict, where both an earlier and later loader loaded a value for
  the same configuration. The default behavior if this is not implemented
  is to take the newest, always, but this behavior can be changed by
  the type.

So, here is a basic implentation that shows how something simple like
{OmniConfig::Type::String String} is implemented:

```ruby
class StringType
  def value(raw)
    # Let nil be nil
    return nil if raw.nil?

    # Otherwise convert it to a string
    raw.to_s
  end
end
```

Here is another type that converts values to an integer, but also
handles merge conflicts by taking the smallest integer:

```ruby
class SmallestInteger
  def value(raw)
    # Convert to an int, always
    raw.to_i
  end

  def merge(old, new)
    [old, new].min
  end
end
```

Given the `SmallestInteger` type, if you had the following situation,
this would be the result:

```
schema = OmniConfig.structure("key" => SmallestInteger)
config = OmniConfig.new(schema)
config.add_loader(Hash.new({ "key" => "3" }))
config.add_loader(Hash.new({ "key" => 2 }))
config.add_loader(Hash.new({ "key" => 5 }))
result = config.load

result["key"] # => 2
```

## Loaders

This section lists all the built-in loaders in OmniConfig as well as
documentation on how you can make your own custom loader.

Loaders are responsible for reading configuration from some source and
turning it into a valid Ruby hash. This hash is then turned into the
proper configuration and types by OmniConfig. Therefore, the life of
a loader is actually quite simple. Some examples of validation a loader
has to do is: verifying a file exists if loading from a file, syntax
checking, etc.

### {OmniConfig::Loader::Hash Hash}

Uses a Ruby Hash passed in as the initializer to this loader as the
configuration value. This is useful for setting early defaults in
the load sequence, as well as basic testing of your configuration. Example:

```ruby
schema = OmniConfig.structure("key" => String)
config = OmniConfig.new(schema)
config.add_loader(Hash.new({ "key" => "value" }))
result = config.load

result["key"] # => "value"
```
