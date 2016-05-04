module Funky
  class Videos
    def initialize(ids:)
      @fb_video = Video.new
      @koala = Koala::Facebook::API.new
      @ids = Array ids
    end

    def fetch_data
      vids = @koala.batch do |b|
        @ids.each do |id|
          b.get_object(id,
            fields: ['likes.summary(true)', 'comments.summary(true)'])
        end
      end
      extract_data(vids)
    end

  private

    def extract_data(vids)
      vids.inject({}) do |result, vid|
        result.merge vid['id'] => {
          'like_count' => vid['likes']['summary']['total_count'],
          'comment_count' => vid['comments']['summary']['total_count']
        }.merge(additional_scraped_data(vid['id']))
      end
    end

    def additional_scraped_data(id)
      @fb_video.uri = "https://www.facebook.com/video.php?v=#{id}"
      { 'share_count' => @fb_video.shares, 'view_count' => @fb_video.views }
    end
  end
end
