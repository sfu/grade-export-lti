require 'test_helper'

class GradingStandardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get grading_standards_show_url
    assert_response :success
  end

  test "should get new" do
    get grading_standards_new_url
    assert_response :success
  end

  test "should get create" do
    get grading_standards_create_url
    assert_response :success
  end

end
