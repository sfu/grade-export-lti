require 'test_helper'

class GradeExportControllerTest < ActionDispatch::IntegrationTest
  test "should get view" do
    get grade_export_view_url
    assert_response :success
  end

  test "should get export" do
    get grade_export_export_url
    assert_response :success
  end

end
