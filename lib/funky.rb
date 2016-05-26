require 'date'
require "funky/version"
require 'funky/errors'
require 'net/http'
require 'funky/connections/api'
require 'funky/configuration'
require "funky/video"

module Funky
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
