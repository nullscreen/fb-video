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
      scraper.likes
    end

    def comment_count
      scraper.comments
    end

    def share_count
      scraper.shares
    end

    def view_count
      scraper.views
    end

    def self.where(id:)
      return nil unless id
      instantiate_collection(fetch_data Array(id))
    end

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
