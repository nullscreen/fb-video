require 'funky/html/page'
require 'funky/html/parser'
require 'funky/url'

module Funky
  class Video < GraphRootNode

    attr_accessor :counters

    @@html_page = HTML::Page.new
    @@html_parser = HTML::Parser.new

    # @return [DateTime] the created time of the video.
    def created_time
      datetime = data[:created_time]
      DateTime.parse datetime if datetime
    end

    # @return [String] the description of the video.
    def description
      data[:description].to_s
    end

    # @return [Float] the length (duration) of the video.
    def length
      data[:length]
    end

    # @return [String] the title of the video.
    def title
      data[:title].to_s
    end

    # see https://developers.facebook.com/docs/graph-api/reference/video/
    # @return [Integer] the total number of likes for the video.
    def count_likes
      data[:likes][:summary][:total_count]
    end

    # @return [Integer] the total number of comments for the video.
    def count_comments
      data[:comments][:summary][:total_count]
    end

    # @return [Integer] the total number of reactions for the video.
    def count_reactions
      data[:reactions][:summary][:total_count]
    end

    # @return [String] the picture URL of the video.
    def picture
      data[:picture]
    end

    # @return [String] the name of Facebook page for the video.
    def page_name
      data.fetch(:from)[:name]
    end

    # @return [String] the id of Facebook page for the video.
    def page_id
      data.fetch(:from)[:id]
    end

    # @return [String] the url of Facebook page for the video.
    def page_url
      "https://www.facebook.com/#{page_id}"
    end

    # @return [Integer] the total number of likes for the video.
    def like_count
      data[:like_count]
    end

    # @return [Integer] the total number of comments for the video.
    def comment_count
      data[:comment_count]
    end

    # @return [Integer] the total number of shares for the video.
    def share_count
      data[:share_count]
    end

    # @return [Integer] the total number of views for the video.
    def view_count
      data[:view_count]
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
      instantiate_collection(fetch_and_parse_data Array(id))
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
      counters = @@html_parser.parse html: @@html_page.get(video_id: video_id), video_id: video_id
      new counters.merge(id: video_id)
    end

    # Similar to #find, but it finds the video by url instead of video id.
    # Fetches the data from Facebook's HTML and instantiates the data
    # into a single Funky::Video object. It can accept one only video url.
    #
    # @example Getting a video by url
    #   url = 'https://www.facebook.com/video.php?v=203203106739575'
    #   Funky::Video.find_by_url!(url) # => #<Funky::Video>
    #
    # @return [Funky::Video] the data scraped from Facebook's HTML
    #   and encapsulated into a Funky::Video object.
    def self.find_by_url!(url)
      url = URL.new(url)
      find(url.video_id)
    end

  private

    def self.fields
      [
        'created_time',
        'description',
        'length',
        'from',
        'picture'
      ]
    end
  end
end
