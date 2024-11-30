require "test_helper"

class Api::V1::EnquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_enquiries_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_enquiries_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_enquiries_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_enquiries_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_enquiries_destroy_url
    assert_response :success
  end
end
