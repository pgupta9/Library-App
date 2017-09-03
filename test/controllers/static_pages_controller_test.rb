require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get afterlogin" do
    get :afterlogin
    assert_response :success
  end

end
