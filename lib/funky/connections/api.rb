require 'funky/connections/base'
require 'json'

module Funky
  # @api private
  module Connection
    class API < Base
      def self.request(id:, fields:)
        uri = URI::HTTPS.build host: host,
          path: "/v2.8/#{id}",
          query: "access_token=#{app_id}%7C#{app_secret}&fields=#{fields}"
        response_for(get_http_request(uri), uri)
      end

      def self.batch_request(ids:, fields:)
        uri = URI::HTTPS.build host: host,
          path: "/",
          query: "include_headers=false&access_token=#{app_id}%7C#{app_secret}"
        batch = create_batch_for ids, fields
        http_request = post_http_request uri
        http_request.set_form_data batch: batch.to_json
        response_for(http_request, uri)
      end

    private

      def self.host
        'graph.facebook.com'
      end

      def self.app_id
        Funky.configuration.app_id
      end

      def self.app_secret
        Funky.configuration.app_secret
      end

      def self.post_http_request(uri)
        Net::HTTP::Post.new uri
      end

      def self.create_batch_for(ids, fields)
        ids.map do |id|
          {"method":"GET", "relative_url": "/v2.8/#{id}?fields=#{fields}"}
        end
      end
    end
  end
end
