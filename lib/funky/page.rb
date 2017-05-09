module Funky
  class Page < GraphRootNode

    # Fetches the data from Facebook Graph API and returns a Funky::Page object.
    # It accepts a page ID.
    #
    # @example Getting a page object
    #   Funky::Page.find 'FullscreenInc' # or
    #   Funky::Page.find '221406534569729'
    #   # => #<Funky::Page @data={:name=>"Fullscreen", :id=>"221406534569729"}>
    #
    # @return [Funky::Page] containing the data fetched by Facebook Graph API.
    def self.find(page_id)
      page = Funky::Connection::API.fetch("#{page_id}?fields=name,username,location,fan_count,featured_video")
      new(page)
    end

    # Fetches data from Facebook Graph API and returns an array of Funky::Video
    # objects belong to the caller page.
    #
    # @example Getting videos under a page
    #   page = Funky::Page.find 'FullscreenInc'
    #   page.videos
    #   # => [#<Funky::Video @data={...}>, #<Funky::Video @data={...}>]
    #
    # @return [Array<Funky::Video>] multiple Funky::Video objects containing data
    #   fetched by Facebook Graph API.
    def videos
      videos = Funky::Connection::API.fetch(
        "#{id}/videos?fields=id,title,description,created_time,length,comments.limit(0).summary(true),likes.limit(0).summary(true),reactions.limit(0).summary(true)",
        is_array: true)
      videos.map {|video| Video.new(video) }
    end

    # Fetches data from Facebook Graph API and returns an array of Funky::Post
    # objects belong to the caller page.
    #
    # @example Getting posts under a page
    #   page = Funky::Page.find 'FullscreenInc'
    #   page.posts
    #   # => [#<Funky::Post @data={...}>, #<Funky::Post @data={...}>]
    #
    # @return [Array<Funky::Post>] multiple Funky::Post objects containing data
    #   fetched by Facebook Graph API.
    def posts
      posts = Funky::Connection::API.fetch_all("#{id}/posts?fields=type,created_time")
      posts.map {|post| Post.new(post)}
    end

    # @note
    #   For example, for www.facebook.com/platform the username is 'platform'.
    # @see https://developers.facebook.com/docs/graph-api/reference/page/
    # @return [String] the alias of the Facebook Page.
    def username
      data[:username]
    end

    # @note
    #   For example, for www.facebook.com/platform the name is
    #   'Facebook For Developers'.
    # @see https://developers.facebook.com/docs/graph-api/reference/page/
    # @return [String] the name of the Facebook Page.
    def name
      data[:name]
    end

    # @return [Integer] the number of people who likes the Facebook page.
    def fan_count
      data[:fan_count]
    end

    # @return [Boolean] if the Facebook page has featured_video
    def has_featured_video?
      !data[:featured_video].nil?
    end

    # @note
    #   location is a Hash that contains more specific properties such as city,
    #   state, zip, etc.
    # @see https://developers.facebook.com/docs/graph-api/reference/page/
    # @return [Hash] the location of the Facebook Page if it is present
    def location
      data.fetch(:location, {})
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [String, nil] the city of the Facebook Page if it is present
    def city
      location[:city]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [String, nil] the street of the Facebook Page if it is present
    def street
      location[:street]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [String, nil] the state of the Facebook Page if it is present
    def state
      location[:state]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [String, nil] the country of the Facebook Page if it is present
    def country
      location[:country]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [String] the zip code of the Facebook Page if it is present
    def zip
      location[:zip]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [Fixnum, nil] the latitude of the Facebook Page if it is present
    def latitude
      location[:latitude]
    end

    # @see https://developers.facebook.com/docs/graph-api/reference/location/
    # @return [Fixnum, nil] the longitude of the Facebook Page if it is present
    def longitude
      location[:longitude]
    end

    # Fetches the data from Facebook's APIs and instantiates the data
    # into an Array of Funky::Page objects. It can accept one page ID or an
    # array of multiple page IDs.
    #
    # @example Getting one page
    #   id = '10153834590672139'
    #   Funky::Page.where(id: id) # => [#<Funky::Page>]
    # @example Getting multiple videos
    #   ids = ['10154439119663508', '10153834590672139']
    #   Funky::Page.where(id: ids) # => [#<Funky::Page>, #<Funky::Page>]
    #
    # @return [Array<Funky::Page>] multiple instances of Funky::Page objects
    #   containing data obtained by Facebook's APIs.
    def self.where(id:)
      return nil unless id
      instantiate_collection(fetch_and_parse_data Array(id))
    end

  private

    def self.fields
      [
        'name',
        'username',
        'location'
      ]
    end
  end
end
