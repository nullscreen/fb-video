module Funky
  class Scraper
    attr_reader :response

    def initialize(uri)
      @response ||= request uri
    end

    def shares
      response.match(/"sharecount":(.*?),/)
      matched_count $1
    end

    def views
      response.match(/<div><\/div><span class="fcg">(.*) Views<\/span>/)
      matched_count $1
    end

    def likes
      response.match /"likecount":(.*?),/
      matched_count $1
    end

    def comments
      response.match /"commentcount":(.*?),/
      matched_count $1
    end

  private

    def matched_count(matched)
      matched ? matched.delete(',').to_i : nil
    end

    def request(uri)
      Net::HTTP.get(URI uri)
    rescue SocketError => e
      if retry?
        sleep 3
        request uri
      else
        raise ConnectionError, e.message
      end
    end

    def retry?
      @retries ||= 0
      max_retries = 2
      if @retries < max_retries
        @retries += 1
        true
      else
        @retries = 0
        false
      end
    end
  end
end
