[![Build Status](https://travis-ci.org/Fullscreen/funky.svg?branch=master)](https://travis-ci.org/Fullscreen/funky)
[![Coverage Status](https://coveralls.io/repos/github/Fullscreen/funky/badge.svg?branch=master)](https://coveralls.io/github/Fullscreen/funky?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/Fullscreen/funky.svg)](https://gemnasium.com/github.com/Fullscreen/funky)
[![Code Climate](http://img.shields.io/codeclimate/github/Fullscreen/funky.svg)](https://codeclimate.com/github/Fullscreen/funky)
[![Gem Version](https://badge.fury.io/rb/funky.svg)](https://badge.fury.io/rb/funky)

# Funky

Funky is a Ruby library to fetch data about videos posted on Facebook, such as their title, description, number of views, comments, shares, and likes.

## How it works

Funky can get *public* Facebook video data whether the Graph API requires insight permission or not. For example, even though the number of shares and views are shown publicly on the web page, the Graph API will not return those results unless the user has insight permission for that video. Using Funky, you can obtain the number of shares and views without insight permissions.

Under the hood, Funky hits Facebook's APIs on some cases, while other cases it will scrape Facebook's HTML to get the data. It's kind of... funky.

## Usage

This is still a very early version, and it currently can only retrieve certain Facebook video data.

### Installing and Configuring Funky

First, add funky to your Gemfile:

```ruby
gem 'funky'
```
Then run `bundle install`.

Funky will require an App ID and an App Secret which you can obtain after registering as a developer on [Facebook for developers](https://developers.facebook.com/).

There are two ways to configure Funky with your App ID and App Secret:

1. By default, Funky will look for the environment variables called `FB_APP_ID` and `FB_APP_SECRET`. You can put those keys in your `.bash_profile` and Funky will work.

    ```
    export FB_APP_ID="YourAppID"
    export FB_APP_SECRET="YourAppSecret"
    ```

2. If you're using this in Rails, you can choose to create an initializer instead and configure the App ID and App Secret like so:

    ```ruby
    Funky.configure do |config|
      config.app_id = 'YourAppID'
      config.app_secret = 'YourAppSecret'
    end
    ```

## API Overview

Funky consists of 2 different surface APIs - one to fetch video data
from Facebook and one to fetch page data from Facebook.

## Pages API

### Use #where clause to get an array of videos

```ruby
ids = ['1487249874853741', '526533744142224']
pages = Funky::Page.where(id: ids)
pages.first.id            # => '1487249874853741'
pages.first.name          # => 'Sony Pictures'
pages.first.username      # => 'SonyPicturesGlobal'

```

## Videos API

### Use #where clause to get an array of videos

```ruby
ids = ['10154439119663508', '10153834590672139']
videos = Funky::Video.where(id: ids)
videos.first.id            # => '10154439119663508'
videos.first.created_time  # => #<DateTime: 2015-12-17T06:29:48+00:00>
videos.first.description   # => "Hugh Jackman coaches Great Britain's..."
videos.first.length        # => 147.05
videos.first.picture       # => "https://scontent.xx.fbcdn.net/v/..."
videos.first.page_name     # => "Moviefone"

```

If a non-existing video ID is passed into the where clause, it is ignored. Other video IDs will still be retrieved.

```ruby
ids = ['10154439119663508', '10153834590672139', 'doesnotexist']
videos = Funky::Video.where(id: ids)
videos.count    # => 2
videos.first.id # => '10154439119663508'
videos.last.id  # => '10153834590672139'
```

### Use #find to get a single video

```ruby
video = Funky::Video.find('10154439119663508')
video.id            # => '10154439119663508'
video.like_count    # => 1169
video.comment_count # => 65
video.share_count   # => 348
video.view_count    # => 10121
```

If a non-existing video ID is passed into #find, Funky::ContentNotFound will be raised.

```ruby
Funky::Video.find('doesnotexist') # => raises Funky::ContentNotFound
```

### Use #find_by_url!(url) to get a single video from a url

```ruby
video = Funky::Video.find_by_url!('https://www.facebook.com/video.php?v=10154439119663508')
video.id            # => '10154439119663508'
video.like_count    # => 1169
video.comment_count # => 65
video.share_count   # => 348
video.view_count    # => 10121
```

If a non-existing video url is passed into #find_by_url!, Funky::ContentNotFound will be raised.

```ruby
Funky::Video.find_by_url!('https://www.facebook.com/video.php?v=doesnotexist')
  # => raises Funky::ContentNotFound
```

The current URL formats are supported:

- `https://www.facebook.com/{page_name}/videos/vb.{alt_page_id}/{video_id}`
- `https://www.facebook.com/{page_name}/videos/{video_id}`
- `https://www.facebook.com/{page_id}/videos/{video_id}`
- `https://www.facebook.com/video.php?v={video_id}`


### Connection error

Should there be a case where Funky is unable to connect to Facebook, `Funky::ConnectionError` will be raised.

```ruby
# Given funky is unable to establish a connection to Facebook
Funky::Video.find('10154439119663508') # => raises Funky::ConnectionError
Funky::Video.where(id: '10154439119663508') # => raises Funky::ConnectionError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fullscreen/funky. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

