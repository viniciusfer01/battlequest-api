require "test_helper"

class Api::V1::PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should show players" do
    player1 = players(:zezin)
    player2 = players(:chiquin)

    get api_v1_players_url

    assert_response :success
    assert_equal player1.id, JSON.parse(response.body)[3]["id"]
    assert_equal player1.name, JSON.parse(response.body)[3]["name"]
    assert_equal player1.score, JSON.parse(response.body)[3]["score"]
    assert_equal player2.id, JSON.parse(response.body)[0]["id"]
    assert_equal player2.name, JSON.parse(response.body)[0]["name"]
    assert_equal player2.score, JSON.parse(response.body)[0]["score"]
  end

  test "should show player stats" do
    player = players(:zezin)
    kills(:one)
    item_pickups(:one)
    quest_completions(:one)
    boss_kills(:one)

    get stats_api_v1_player_url(player)

    assert_response :success
    assert_equal player.id, JSON.parse(response.body)["player_id"]
    assert_equal player.name, JSON.parse(response.body)["name"]
    assert_equal player.score, JSON.parse(response.body)["score"]
    assert_equal 1, JSON.parse(response.body)["kills"]
    assert_equal 0, JSON.parse(response.body)["deaths"]
    assert_equal 16, JSON.parse(response.body)["items_collected"]
    assert_equal 1, JSON.parse(response.body)["quests_completed"]
  end
end
