require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should log in with valid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: 'password' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should not log in with invalid credentials" do
    post user_session_path, params: { user: { email: @user.email, password: 'wrongpassword' } }
    assert_response :unprocessable_entity # Devise invalid credentials pe 401 return karta hai
  end
end
