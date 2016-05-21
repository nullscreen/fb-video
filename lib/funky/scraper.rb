module Funky
  class Scraper
    attr_reader :uri

    def initialize(uri)
      @uri = URI uri
    end

    def shares
      response.match(/"sharecount":(.*?),/)
      $1 ? $1.delete(',').to_i : nil
    end

    def views
      response.match(/<div><\/div><span class="fcg">(.*) Views<\/span>/)
      $1 ? $1.delete(',').to_i : nil
    end

  private

    def response
      @response ||= Net::HTTP.get(uri)
    end
  end
end
