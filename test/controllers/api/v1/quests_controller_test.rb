require "test_helper"

class QuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    QuestStart.delete_all
    QuestCompletion.delete_all

    @player = players(:zezin)

    QuestStart.create!(player: @player, quest_id: "q1", quest_name: "A Great Start")
    QuestCompletion.create!(player: @player, quest_id: "q1", xp_gained: 100, gold_gained: 10)

    QuestStart.create!(player: @player, quest_id: "q2", quest_name: "Goblin Menace")
  end

  test "should get all started quests for a player" do
    get started_api_v1_player_quests_url(@player)
    assert_response :success

    quests = JSON.parse(response.body)
    assert_equal 2, quests.size
  end

  test "started quests should respect the limit parameter" do
    get started_api_v1_player_quests_url(@player), params: { limit: 1 }
    assert_response :success

    quests = JSON.parse(response.body)
    assert_equal 1, quests.size
    assert_equal "q2", quests.first["quest_id"]
  end

  test "should get all completed quests for a player" do
    get completed_api_v1_player_quests_url(@player)
    assert_response :success

    quests = JSON.parse(response.body)
    assert_equal 1, quests.size
    assert_equal "q1", quests.first["quest_id"]
  end

  test "completed quests should respect the limit parameter" do
    QuestCompletion.create!(player: @player, quest_id: "q2", xp_gained: 200, gold_gained: 50)

    get completed_api_v1_player_quests_url(@player), params: { limit: 1 }
    assert_response :success

    quests = JSON.parse(response.body)
    assert_equal 1, quests.size
    assert_equal "q2", quests.first["quest_id"]
  end

  test "should return 404 if player not found for started quests" do
    get started_api_v1_player_quests_url(player_id: "invalid")
    assert_response :not_found
    assert_includes response.body, "Player not found"
  end

  test "should return 404 if player not found for completed quests" do
    get completed_api_v1_player_quests_url(player_id: "invalid")
    assert_response :not_found
  end
end
