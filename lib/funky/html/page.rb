module Funky
  module HTML
    class Page
      def initialize(video_id:)
        @video_id = video_id
      end

      def get
        if response.body.include? '<meta name="description"'
          response.body
        else
          raise ContentNotFound, 'Please double check the ID and try again.'
        end
      end

      def uri
        URI::HTTPS.build host:  'www.facebook.com',
                         path:  '/video.php',
                         query: "v=#{@video_id}"
      end

      def http_request
        Net::HTTP::Get.new(uri.request_uri)
      end

      def response
        Net::HTTP.start(uri.host, 443, use_ssl: true) do |http|
          http.request http_request
        end
      rescue SocketError => e
        raise ConnectionError, e.message
      end
    end
  end
end
