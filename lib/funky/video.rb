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

  private

    def scraper
      url = "https://www.facebook.com/video.php?v=#{data['id']}"
      @scraper ||= Scraper.new url
    end

    def summary_for(attribute)
      data.fetch(attribute, {}).fetch('summary', {}).fetch('total_count', nil)
    end
  end
end
