require "test_helper"

class BakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bakes_index_url
    assert_response :success
  end

  test "should get show" do
    get bakes_show_url
    assert_response :success
  end

  test "should get new" do
    get bakes_new_url
    assert_response :success
  end

  test "should get edit" do
    get bakes_edit_url
    assert_response :success
  end

  test "should get create" do
    get bakes_create_url
    assert_response :success
  end

  test "should get update" do
    get bakes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get bakes_destroy_url
    assert_response :success
  end
end
