require 'test_helper'

class LookupControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get lookup_show_url
    assert_response :success
  end

end
