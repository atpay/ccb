# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ccb/version'
# require 'httparty'
# require 'active_support'
# require 'active_model'
# gem 'httparty'
# gem 'activesupport'
# gem 'activemodel'
# gem 'rake'
# group :test do
#   gem 'minitest'
# #  gem 'webmock'
# #  gem 'vcr'
#  gem 'turn', :require => false
# end
# group :development do
#   gem 'rb-inotify', :require => false
#   gem 'rb-fsevent', :require => false
#   gem 'rb-fchange', :require => false
#   gem 'guard'
#   gem 'guard-minitest'
# end

Gem::Specification.new do |spec|
  spec.name          = "ccb"
  spec.version       = Ccb::VERSION
  spec.authors       = ["Ben Hamilton"]
  spec.email         = ["ben.hamilton@nwcfoursquare.org"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
