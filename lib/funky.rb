require 'date'
require 'net/http'

require "funky/version"
require 'funky/errors'
require 'funky/connections/api'
require 'funky/configuration'
require "funky/graph_root_node"
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
