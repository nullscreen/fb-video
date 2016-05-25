module Funky
  class Scraper
    attr_reader :response

    def initialize(id)
      @response ||= Connection::Web.request(id: id).body
    rescue SocketError => e
      raise ConnectionError, e.message
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
  end
end
