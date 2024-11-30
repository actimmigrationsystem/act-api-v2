require "test_helper"

class Client::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get client_dashboard_index_url
    assert_response :success
  end
end
