module Funky
  class Video
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # @return [String] the video ID.
    def id
      data['id']
    end

    # @return [DateTime] the created time of the video.
    def created_time
      datetime = data['created_time']
      DateTime.parse datetime if datetime
    end

    # @return [String] the description of the video.
    def description
      data['description']
    end

    # @return [Float] the length (duration) of the video.
    def length
      data['length']
    end

    # @return [String] the picture URL of the video.
    def picture
      data['picture']
    end

    # @return [Integer] the total number of likes for the video.
    def like_count
      scraper.likes
    end

    # @return [Integer] the total number of comments for the video.
    def comment_count
      scraper.comments
    end

    # @return [Integer] the total number of shares for the video.
    def share_count
      scraper.shares
    end

    # @return [Integer] the total number of views for the video.
    def view_count
      scraper.views
    end

    # Fetches the data from Facebook's APIs and instantiates the data
    # into an Array of Funky::Video objects. It can accept one video ID or an
    # array of multiple video IDs.
    #
    # @example Getting one video
    #   id = '10153834590672139'
    #   Funky::Video.where(id: id) # => [#<Funky::Video>]
    # @example Getting multiple videos
    #   ids = ['10154439119663508', '10153834590672139']
    #   Funky::Video.where(id: ids) # => [#<Funky::Video>, #<Funky::Video>]
    #
    # @return [Array<Funky::Video>] multiple instances of Funky::Video objects
    #   containing data obtained by Facebook's APIs.
    def self.where(id:)
      return nil unless id
      instantiate_collection(fetch_data Array(id))
    end

    # Fetches the data from Facebook's HTML and instantiates the data
    # into a single Funky::Video object. It can accept one only video ID.
    #
    # @example Getting a video
    #   Funky::Video.find('10153834590672139') # => #<Funky::Video>
    #
    # @return [Funky::Video] the data scraped from Facebook's HTML
    #   and encapsulated into a Funky::Video object.
    def self.find(video_id)
      video = new('id' => video_id)
      if video.view_count
        video
      else
        raise ContentNotFound, 'Please double check the ID and try again.'
      end
    end

  private

    def scraper
      url = "https://www.facebook.com/video.php?v=#{data['id']}"
      @scraper ||= Scraper.new url
    end

    def self.fetch_data(ids)
      koala.batch do |b|
        ids.each do |id|
          b.get_object(id, fields: fields) do |object|
            object unless object.is_a? StandardError
          end
        end
      end.compact
    rescue Faraday::ConnectionFailed => e
      raise ConnectionError, e.message
    end

    def self.instantiate_collection(items)
      items.collect { |item| new item }
    end

    def self.koala
      @koala ||= Koala::Facebook::API.new(
        "#{Funky.configuration.app_id}|#{Funky.configuration.app_secret}")
    end

    def self.fields
      [
        'created_time',
        'description',
        'length',
        'picture'
      ]
    end
  end
end
