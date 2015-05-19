require_relative '../test_helper'

class PersonTest < Minitest::Test
  def setup
    @person1 = CCB::Person.new(:first_name => "First", :last_name => "Last")
    @person2 = CCB::Person.new()
    # @all_people = CCB::Person.find(:all) # see test_find_all_not_empty
  end

  def test_ccb_base_inheritance
    assert_equal(true, CCB::Person.ancestors.include?(CCB::Base))
  end

  def test_make_full_name
    assert_equal(@person1.full_name, "First Last")
  end

  def test_exception_when_no_full_name
    assert_raises(RuntimeError) { @person2.full_name }
  end

  # Not performing this test as it requires live credentials
  #   if credientials can be used locally this can validate that
  #   the credentials are valid and the API call is functional
  #  def test_find_all_not_empty
  #   refute_empty(@all_people)
  # end
end

