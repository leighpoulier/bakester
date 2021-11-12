require "test_helper"

class BakeJobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bake_jobs_index_url
    assert_response :success
  end

  test "should get show" do
    get bake_jobs_show_url
    assert_response :success
  end
end
