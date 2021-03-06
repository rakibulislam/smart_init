# Smart Init [![Build Status](https://travis-ci.org/pawurb/smart_init.svg)](https://travis-ci.org/pawurb/smart_init) [![Gem Version](https://badge.fury.io/rb/smart_init.svg)](http://badge.fury.io/rb/smart_init)

Do you find yourself writing a lot of boilerplate code like that?

```ruby
def initialize(network_provider, api_token)
  @network_provider = network_provider
  @api_token = api_token
end

def self.call(network_provider, api_token)
  new(network_provider, api_token).call
end
```

Gem provides a simple DSL for getting rid of it. It offers an alternative to using `Struct.new` which does not check for number of parameters provided in initializer, exposes getters and instantiates unecessary class instances.

**Smart Init** offers a unified API convention for stateless service objects, accepting values in initializer and exposing one public class method `call` which instantiates new objects and accepts arguments passed to initializer.

Check out [this blog post](https://pawelurbanek.com/2018/02/12/ruby-on-rails-service-objects-and-testing-in-isolation/) for my reasoning behind this approach to service object pattern.

## Installation

In your Gemfile

```ruby
gem 'smart_init'
```

## API

You can use it either by extending a module:

```ruby
class ApiClient
  extend SmartInit

  initialize_with :network_provider, :api_token
end

```

or subclassing:

```ruby
class ApiClient < SmartInit::Base
  initialize_with :network_provider, :api_token
end

```

Now you can just:

```ruby
object = ApiClient.new(network_provider: Faraday.new, api_token: 'secret_token')
# <ApiClient:0x007fa16684ec20 @network_provider=Faraday<...>, @api_token="secret_token">
```

If you omit a required attribute an `ArgumentError` will be thrown:

```ruby
object = ApiClient.new(network_provider: Faraday.new)

# ArgumentError (missing required attribute api_token)
```

You can also use `is_callable` method:

```ruby
class Calculator < SmartInit::Base
  initialize_with :data
  is_callable

  def call
    ...
    result
  end
end

Calculator.call(data: data) => result
```

Optionally you can customize a callable method name:

```ruby
class Routine < SmartInit::Base
  initialize_with :params
  is_callable method_name: :run!

  def run!
    ...
  end
end

Routine.run!(params: params)
```

### Default arguments

You can use hash based, default argument values:

```ruby
class Adder < SmartInit::Base
  initialize_with :num_a, num_b: 2
  is_callable

  def call
    num_a + num_b
  end
end

Adder.call(num_a: 2) => 4
Adder.call(num_a: 2, num_b: 3) => 5

```

## Legacy Arguments API

Alternatively you can use a legacy API without hash arguments and default values:

```ruby
class Calculator < SmartInit::Base
  initialize_with_args :data
  is_callable

  def call
    ...
    result
  end
end

Calculator.call(data) => result
```
