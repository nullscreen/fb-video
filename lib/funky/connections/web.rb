require 'funky/connections/base'

module Funky
  module Connection
    class Web < Base
      def self.request(id:)
        uri = URI::HTTPS.build host:  'www.facebook.com',
                               path:  '/video.php',
                               query: "v=#{id}"
        response_for(get_http_request(uri), uri)
      end
    end
  end
end
