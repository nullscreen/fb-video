require 'date'
require "funky/version"
require 'funky/errors'
require 'net/http'
require 'funky/connections/api'
require 'funky/configuration'
require "funky/data_parser"
require "funky/video"
require "funky/page"

module Funky
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
