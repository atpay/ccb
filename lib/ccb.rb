require_relative "ccb/version"

require 'active_support'
require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'faraday'
require 'yaml'
require 'base64'
# require 'faraday-cookie_jar'

RAILS_ENV = "development" unless defined? RAILS_ENV

def refresh_ccb
  load __FILE__
  require File.dirname(__FILE__) + '/ccb/base.rb'
  Dir[File.dirname(__FILE__) + '/ccb/*.rb'].each do |file|
    #require file
    load file
  end
  true
end

class CCB
  def initialize(config)
    @connection = CCB::Connection.new(config)
  end

  def groups(args = {}, filters = {})
    CCB::Group.find(@connection, args, filters)
  end
end

require_relative "ccb/base"
# require_relative "ccb/ability.rb"
# require_relative "ccb/address.rb"
require_relative "ccb/connection.rb"
# require_relative "ccb/country.rb"
# require_relative "ccb/event.rb"
require_relative "ccb/group.rb"
# require_relative "ccb/helper_method.rb"
# require_relative "ccb/participation.rb"
require_relative "ccb/person.rb"
# require_relative "ccb/person_attendance.rb"
# require_relative "ccb/position.rb"
# require_relative "ccb/user_group.rb"
# require_relative "ccb/version.rb"
