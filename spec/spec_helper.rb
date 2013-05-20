require_relative '../lib/ccb'
require 'minitest/spec'
require 'minitest/autorun'
# require 'webmock/minitest'
# require 'vcr'
require 'turn'
Turn.config do |c|
 # :outline  - turn's original case/test outline mode [default]
 c.format  = :outline
 # turn on invoke/execute tracing, enable full backtrace
 c.trace   = true
 # use humanized test names (works only with :outline format)
 c.natural = true
end
# #VCR config
# VCR.configure do |c|
#   c.cassette_library_dir = 'spec/fixtures/ccb_cassettes'
#   c.hook_into :webmock
# end

