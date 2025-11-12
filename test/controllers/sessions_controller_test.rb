require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should login with valid credentials" do
    post login_path, params: { email: @user.email, password: 'password123' }
    assert_redirected_to tasks_path
  end

  test "should logout and redirect" do
    post login_path, params: { email: @user.email, password: 'password123' }
    delete logout_path
    assert_redirected_to root_path
  end
end
