require_relative '../lib/ccb'
require 'minitest/spec'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

class Minitest::Test
  # @@fb_client = Koala::Facebook::API.new(OAUTH_ACCESS_TOKEN)
end

#VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures'
  c.hook_into :webmock
end

