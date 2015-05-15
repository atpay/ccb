#require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
require (File.expand_path('./../../../spec_helper', __FILE__))
describe CCB::Person do
  it "must inherit from CCB::Base" do
    assert_equal true, CCB::Person.ancestors.include?(CCB::Base)
  end

  it "can make a full name" do
    person = CCB::Person.new(:first_name => "Hello", :last_name => "World")
    assert person.full_name == "Hello World"
  end

  it "must raise exception when no full name is possible" do
    person = CCB::Person.new()
    lambda {person.full_name}.must_raise(RuntimeError)
  end
   it "must always get something from api even with bad credentials" do
    users = CCB::Person.find(:all)
    users.wont_be_nil
  end

end
