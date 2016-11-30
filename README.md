# Rspec::Coverage

_Inspired by Ryan Davis' RubyConf 2016 talk._

SimpleCov-backed coverage-tracking tools for RSpec. Coverage is only recorded in a `describe` block for the class being `describe`d, which prevents incidental coverage of unverified lines in collaborators and encourages better test design.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-coverage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-coverage

## Usage

As early as possible in your code (before your classes load), add

```
require 'rspec/coverage'
# Takes the same optional args as SimpleCov.start
RSpec::Coverage.start
```

and use `rspec` as normal. Any `describe` block will automatically filter coverage to the class under test. You can also add a `covers:` annotation to control filtering.

```
RSpec.describe "User with collaborators", covers: [User, Collaborator] do
  ...
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jamesdabbs/rspec-coverage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
