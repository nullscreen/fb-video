module Funky
  # @api private
  module Connection
    class Base

    private

      def self.get_http_request(uri)
        Net::HTTP::Get.new(uri.request_uri)
      end

      def self.response_for(http_request, uri, max_retries = 5)
        response = Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
          http.request http_request
        end
        if response.is_a? Net::HTTPSuccess
          response
        elsif response.is_a? Net::HTTPServerError
          sleep_and_retry_response_for(http_request, uri, max_retries, response.body)
        else
          raise ContentNotFound, "Error #{response.code}: #{response.body}"
        end
      rescue SocketError => e
        sleep_and_retry_response_for(http_request, uri, max_retries, e.message)
      end

      def self.sleep_and_retry_response_for(http_request, uri, retries, message)
        if retries > 0
          sleep (6 - retries) ** 2
          response_for http_request, uri, retries - 1
        else
          raise ConnectionError, message
        end
      end

      def self.json_for(uri, max_retries = 3)
        response = response_for(get_http_request(uri), uri)
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
