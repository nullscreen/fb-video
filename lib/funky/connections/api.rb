require 'funky/connections/base'
require 'json'

module Funky
  # @api private
  module Connection
    class API < Base
      def self.fetch(path_query, is_array: false)
        uri = URI "https://#{host}/v2.8/#{path_query}&limit=100&access_token=#{app_id}%7C#{app_secret}"
        is_array ? fetch_multiple_pages(uri) : json_for(uri)
      end

      def self.fetch_multiple_pages(uri)
        json = json_for(uri)
        if json[:data].empty?
          []
        else
          timestamp = json[:data][-1][:created_time]
          if @previous_timestamp == timestamp
            []
          else
            @previous_timestamp = timestamp
            new_query = URI.decode_www_form(uri.query).to_h.merge('until' => Time.parse(timestamp).to_i)
            uri.query = URI.encode_www_form(new_query)
            json[:data] + fetch_multiple_pages(uri)
          end
        end
      end

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
