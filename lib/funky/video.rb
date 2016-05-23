module Funky
  class Video
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def id
      data['id']
    end

    def created_time
      datetime = data['created_time']
      DateTime.parse datetime if datetime
    end

    def description
      data['description']
    end

    def length
      data['length']
    end

    def like_count
      scrape.likes
    end

    def comment_count
      scrape.comments
    end

    def share_count
      scrape.shares
    end

    def view_count
      scrape.views
    end

    def self.where(ids:)
      return nil unless ids
      instantiate_collection(fetch_data ids)
    end

  private

    def scrape
      url = "https://www.facebook.com/video.php?v=#{data['id']}"
      @scrape ||= Scraper.new url
    end

    def self.fetch_data(ids)
      ids = Array ids
      koala.batch do |b|
        ids.each do |id|
          b.get_object(id, fields: fields) do |object|
            object unless object.is_a? StandardError
          end
        end
      end.compact
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
        'length'
      ]
    end
  end
end
