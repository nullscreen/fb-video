module Funky
  # @api private
  module Connection
    class Base

    private

      def self.post_http_request(uri, form_data={})
        http_request = Net::HTTP::Post.new uri
        http_request.set_form_data form_data
        http_request
      end

      def self.get_http_request(uri)
        Net::HTTP::Get.new(uri)
      end

      def self.response_for(http_request, uri, max_retries = 5)
        uri = uri_with_query(uri, access_token: app_access_token)
        http_request = req_with_query(http_request, access_token: app_access_token)

        response = Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
          http.request http_request
        end
        if response.is_a? Net::HTTPSuccess
          response
        elsif response.is_a? Net::HTTPServerError
          sleep_and_retry_response_for(http_request, uri, max_retries, response.body)
        elsif response.is_a?(Net::HTTPBadRequest) && response.body =~ /access token/i
          @app_access_token = nil
          response_for(http_request, uri)
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

      def self.uri_with_query(uri, query={})
        return nil if uri.nil?
        new_query = URI.decode_www_form(uri.query).to_h.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}.merge(query)
        uri.query = URI.encode_www_form(new_query)
        uri
      end

      def self.req_with_query(http_request, query={})
        return nil if http_request.nil?
        new_uri = uri_with_query(http_request.uri, query)
        case http_request
          when Net::HTTP::Get
            get_http_request(new_uri)
          when Net::HTTP::Post
            req = Net::HTTP::Post.new new_uri
            req.set_form_data URI.decode_www_form(http_request.body)
            req
        end
      end

      def self.app_access_token
        @app_access_token ||= begin
          uri = URI::HTTPS.build host: host, path: "/v2.8/oauth/access_token",
            query: URI.encode_www_form({client_id: app_id, client_secret: app_secret, grant_type: 'client_credentials'})
          req = get_http_request(uri)
          response = Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
            http.request req
          end
          JSON.parse(response.body, symbolize_names: true)[:access_token]
        end
      end
    end
  end
end
