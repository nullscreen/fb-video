require 'koala'

module Koala
  module Facebook
    class OAuth
      # Creates a new OAuth client.
      #
      # @param app_id [String, Integer] a Facebook application ID
      # @param app_secret a Facebook application secret
      # @param oauth_callback_url the URL in your app to which users authenticating with OAuth will be sent
      def initialize(app_id = nil, app_secret = nil, oauth_callback_url = nil)
        @app_id = app_id || ENV['FB_APP_ID']
        @app_secret = app_secret || ENV['FB_APP_SECRET']
        @oauth_callback_url = oauth_callback_url
      end
    end

    class API
      # Creates a new API client.
      # @param [String] access_token access token
      # @param [String] app_secret app secret, for tying your access tokens to your app secret
      #                 If you provide an app secret, your requests will be
      #                 signed by default, unless you pass appsecret_proof:
      #                 false as an option to the API call. (See
      #                 https://developers.facebook.com/docs/graph-api/securing-requests/)
      # @note If no access token is provided, you can only access some public information.
      # @return [Koala::Facebook::API] the API client
      def initialize(access_token = nil, app_secret = nil)
        @access_token = access_token || OAuth.new.get_app_access_token
        @app_secret = app_secret || ENV['FB_APP_SECRET']
      end
    end
  end
end
