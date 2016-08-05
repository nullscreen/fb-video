module Funky
  # @api private
  module HTML
    class Page
      def get(video_id:)
        body = response_for(video_id).body
        if body.include? '<meta name="description"'
          body
        else
          raise ContentNotFound, 'Please double check the ID and try again.'
        end
      end

    private

      def response_for(video_id)
        uri = uri_for video_id
        request = Net::HTTP::Get.new(uri.request_uri)
        Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
          http.request request
        end
      rescue SocketError => e
        raise ConnectionError, e.message
      end

      def uri_for(video_id)
        URI::HTTPS.build host:  'www.facebook.com',
                         path:  '/video.php',
                         query: "v=#{video_id}&locale=en_US"
      end
    end
  end
end
