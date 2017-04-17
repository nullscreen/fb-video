module Funky
  # @api private
  module Connection
    class Base

    private

      def self.get_http_request(uri)
        Net::HTTP::Get.new(uri.request_uri)
      end

      def self.response_for(http_request, uri)
        response = Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
          http.request http_request
        end
        response
      rescue SocketError => e
        raise ConnectionError, e.message
      end

      def self.json_for(uri)
        response = response_for(get_http_request(uri), uri)
        if response.code == '200'
          JSON.parse(response.body, symbolize_names: true)
        else
          raise ContentNotFound, "Error #{response.code}: #{response.body}"
        end
      end
    end
  end
end
