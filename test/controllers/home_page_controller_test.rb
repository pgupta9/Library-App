require 'test_helper'

class HomePageControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end
=begin
  test "should get about" do
    get about_path
    assert_response :success
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
  end
  
  
  
=end

end
