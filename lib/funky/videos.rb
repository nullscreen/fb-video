module Funky
  class Videos
    def initialize(ids: nil)
      @koala = Koala::Facebook::API.new(
        "#{Funky.configuration.app_id}|#{Funky.configuration.app_secret}")
      @ids = ids
    end

    def where(ids: @ids, fields:)
      return nil unless ids
      fetch_data ids, fields
    end

  private

    def fetch_data(ids, fields)
      fields = Array fields
      ids = Array ids
      items = []
      @koala.batch do |b|
        ids.each do |id|
          b.get_object(id, fields: fields) do |object|
            items << new_video(object) unless object.is_a? StandardError
          end
        end
      end
      items
    end

    def new_video(data)
      Video.new data
    end
  end
end
