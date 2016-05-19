module Funky
  class Scraper
    attr_reader :uri

    def initialize(uri = nil)
      @uri = URI uri if uri
    end

    def shares
      response.match(/"sharecount":(.*?),/)
      $1 ? $1.delete(',').to_i : nil
    end

    def views
      response.match(/<div><\/div><span class="fcg">(.*) Views<\/span>/)
      $1 ? $1.delete(',').to_i : nil
    end

    def uri=(uri)
      reset_response
      @uri = URI uri
    end

  private

    def reset_response
      @response = nil
    end

    def response
      raise "URI needs to be set" unless uri
      @response ||= Net::HTTP.get(uri)
    end
  end
end
