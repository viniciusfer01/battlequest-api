require "test_helper"

class Api::V1::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_token = ApiToken.create!
  end

  test "should get index with valid token" do
    get api_v1_dashboard_index_url, headers: { "Authorization" => "Bearer #{@api_token.token}" }
    assert_response :success

    dashboard_data = JSON.parse(response.body)

    assert dashboard_data.key?("active_players")
    assert dashboard_data.key?("total_score")
    assert dashboard_data.key?("top_items")
    assert dashboard_data.key?("top_killers")
    assert dashboard_data.key?("bosses_defeated")
  end

  test "should fail without a token" do
    get api_v1_dashboard_index_url
    assert_response :unauthorized
  end

  test "should fail with an invalid token" do
    get api_v1_dashboard_index_url, headers: { "Authorization" => "Bearer invalid-token" }
    assert_response :unauthorized
  end
end
