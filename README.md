[![GitHub Actions](https://github.com/hana-da/rack-content_disposition_helper/actions/workflows/test.yml/badge.svg)](https://github.com/hana-da/rack-content_disposition_helper/actions/workflows/test.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/27559fca466cbad7698d/maintainability)](https://codeclimate.com/github/hana-da/rack-content_disposition_helper/maintainability)
[![Gem Version](https://badge.fury.io/rb/rack-content_disposition_helper.svg)](https://badge.fury.io/rb/rack-content_disposition_helper)
[![GitHub](https://img.shields.io/github/license/hana-da/rack-content_disposition_helper)](https://github.com/hana-da/rack-content_disposition_helper/blob/main/MIT-LICENSE)

# Rack::ContentDispositionHelper

Rack::ContentDispositionHelper is Rack middleware that rewrites the decoded `filename*` directive in the Content-Disposition response header as the value of the `filename` directive.

Safari does not use `filename*` if the size of the Content-Disposition response header exceeds 254Bytes, but this middleware is helpful in such cases.

This middleware checks that the User-Agent value in the request header is Safari-like.
If the User-Agent is not Safari-like, no processing is performed.

## Usage example

### Rails app

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'rack-content_disposition_helper'
```

And then execute:

```
$ bundle
```

This will load rack-content_disposition_helper and set it up as a Rails middleware. The middleware is inserted for all of environment.

You don't need to add middleware to rails middleware stack. 

### Sinatra and other Rack apps

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'rack-content_disposition_helper'
```

And then execute:

```
$ bundle
```

For Sinatra and other Rack apps, add this to config.ru:

```ruby
# config.ru

# Bundler.require or require 'rack/content_disposition_helper'
use Rack::ContentDispositionHelper
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hana-da/rack-content_disposition_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hana-da/rack-content_disposition_helper/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rack::ContentDispositionHelper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hana-da/rack-content_disposition_helper/blob/master/CODE_OF_CONDUCT.md).
