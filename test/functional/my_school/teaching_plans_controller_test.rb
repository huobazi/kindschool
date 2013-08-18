require 'test_helper'

class MySchool::TeachingPlansControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
