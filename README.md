# Funky

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/funky`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'funky'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install funky

## Usage

You can send `fetch_data` method to a `Funky::Videos` object, which should be initialized with keyward argument `ids`, for an array of video id strings.

```
ids = ['10154439119663508', '10153834590672139']
fb = Funky::Videos.new(ids: ids)
fb.fetch_data
# => {"10154439119663508"=>{"like_count"=>1169, "comment_count"=>65, "share_count"=>425, "view_count"=>33713}, "10153834590672139"=>{"like_count"=>535, "comment_count"=>36, "share_count"=>348, "view_count"=>19121}}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/funky. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

