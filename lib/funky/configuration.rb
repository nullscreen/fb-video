module Funky
  class Configuration
    attr_accessor :app_id, :app_secret

    def initialize
      @app_id = ENV['FB_APP_ID']
      @app_secret = ENV['FB_APP_SECRET']
    end
  end
end
