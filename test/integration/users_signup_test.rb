require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid sign up information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: {name: "",
                                      email: "user@invalid",
                                      password: "foo",
                                      password_confirmation: "bar"}}
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Hung Tran",
                                         email: "hungtran.nh97@gmail.com",
                                         password: "hungtran",
                                         password_confirmation: "hungtran" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # test login before activation
    log_in_as(user)
    assert_not is_logged_in?
    # activate account with invalid token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not user.activated?

    # activate account with invalid email
    get edit_account_activation_path(user.activation_token, email: "wrong email")
    assert_not user.activated?

    # activate account with valid token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
