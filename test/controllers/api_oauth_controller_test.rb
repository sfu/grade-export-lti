require 'test_helper'

class ApiOauthControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get api_oauth_start_url
    assert_response :success
  end

  test "should get exchange_code_token" do
    get api_oauth_exchange_code_token_url
    assert_response :success
  end

  test "should get logout" do
    get api_oauth_logout_url
    assert_response :success
  end

end
