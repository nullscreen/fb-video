require "funky/version"
require 'koala'
require 'funky/configuration'
require 'funky/scraper'
require "funky/video"
require "funky/videos"

module Funky
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
