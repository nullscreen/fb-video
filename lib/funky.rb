require 'date'
require "funky/version"
require 'funky/errors'
require 'net/http'
require 'funky/connections/web'
require 'funky/connections/api'
require 'funky/configuration'
require 'funky/scraper'
require "funky/video"

module Funky
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
