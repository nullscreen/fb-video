# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funky/version'

Gem::Specification.new do |spec|
  spec.name          = "funky"
  spec.version       = Funky::VERSION
  spec.authors       = ["Philip Nguyen"]
  spec.email         = ["philip.nguyen@fullscreen.net"]

  spec.summary       = "Funky is a Ruby library to fetch video data."
  spec.description   = "Funky is a Ruby library to fetch data about videos posted on Facebook, such as their title, description, number of views, comments, shares, and likes. Funky can obtain those public data regardless of whether you have insight permission. Funky is fully tested."
  spec.homepage      = "https://github.com/Fullscreen/funky"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "0.11.2"
  spec.add_development_dependency "yard", "0.9.12"
  spec.add_development_dependency 'coveralls', "0.8.13"
end
