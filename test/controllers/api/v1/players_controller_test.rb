require "test_helper"

class Api::V1::PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should show players" do
    player1 = players(:one)
    player2 = players(:two)

    get api_v1_players_url

    assert_response :success
    assert_equal player1.id, JSON.parse(response.body)[1]["id"]
    assert_equal player1.name, JSON.parse(response.body)[1]["name"]
    assert_equal player1.score, JSON.parse(response.body)[1]["score"]
    assert_equal player2.id, JSON.parse(response.body)[0]["id"]
    assert_equal player2.name, JSON.parse(response.body)[0]["name"]
    assert_equal player2.score, JSON.parse(response.body)[0]["score"]
  end
end
