require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  test "should get sync" do
    get :sync
    assert_response :success
  end

end
