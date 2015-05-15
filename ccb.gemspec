# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ccb/version'

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

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'activemodel'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'guard', '~> 2.8'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
# gem 'rb-inotify', :require => false
# gem 'rb-fsevent', :require => false
# gem 'rb-fchange', :require => false
# gem 'minitest'
# gem 'webmock'
# gem 'vcr'

end
