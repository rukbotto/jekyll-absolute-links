# Jekyll Absolute Links

Absolute link converter for Jekyll sites. Crawls the generated HTML files in
search of relative links and transform them to absolute links by prepending the
site domain.

## Installation

Add this line to your Gemfile:

```ruby
gem "jekyll-absolute-links"
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install jekyll-absolute-links
```

Finally add this line to `gems` setting in your `_config.yml` file:

```yaml
gems:
  - jekyll-absolute-links
```

## Usage

There's really nothing more to do. Links will be transformed automatically only
for production site.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rukbotto/jekyll-absolute-links.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
