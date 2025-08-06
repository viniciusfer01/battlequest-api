require "test_helper"

class Api::V1::LeaderboardControllerTest < ActionDispatch::IntegrationTest
  test "should rank players by score" do
    players(:zezin)
    players(:chiquin)
    players(:toin)
    players(:manezin)

    get api_v1_leaderboard_index_url
    assert_response :success
    assert_equal 4, JSON.parse(response.body).length
    assert_equal "Zezin", JSON.parse(response.body).last["name"]
    assert_equal "Chiquin", JSON.parse(response.body)[2]["name"]
    assert_equal "Toin", JSON.parse(response.body)[1]["name"]
    assert_equal "Manezin", JSON.parse(response.body).first["name"]
  end
end
