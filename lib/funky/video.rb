module Funky
  class Video
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def like_count
      summary_for 'likes'
    end

    def comment_count
      summary_for 'comments'
    end

    def share_count
      scraper.shares
    end

    def view_count
      scraper.views
    end

    def self.where(ids:, fields:)
      return nil unless ids
      instantiate_videos(fetch_data ids, fields)
    end

  private

    def scraper
      url = "https://www.facebook.com/video.php?v=#{data['id']}"
      @scraper ||= Scraper.new url
    end

    def summary_for(attribute)
      data.fetch(attribute, {}).fetch('summary', {}).fetch('total_count', nil)
    end

    def self.fetch_data(ids, fields)
      fields = Array fields
      ids = Array ids
      koala.batch do |b|
        ids.each do |id|
          b.get_object(id, fields: fields) do |object|
            object unless object.is_a? StandardError
          end
        end
      end.compact
    end

    def self.instantiate_videos(items)
      items.collect { |item| new item }
    end

    def self.koala
      @koala ||= Koala::Facebook::API.new(
        "#{Funky.configuration.app_id}|#{Funky.configuration.app_secret}")
    end
  end
end
