require_relative '../test_helper'

class ConnectionTest < Minitest::Test
  def setup
  end

  def test_ccb_base_inheritance
    assert_equal(true, CCB::Connection.ancestors.include?(CCB::Base))
  end
end
