require "test_helper"

class Api::V1::PlayersControllerTest < ActionDispatch::IntegrationTest
 setup do
    Kill.delete_all
    ItemPickup.delete_all
    QuestStart.delete_all
    QuestCompletion.delete_all
    BossKill.delete_all
  end

  test "should show players" do
    get api_v1_players_url
    assert_response :success
    assert_equal 4, JSON.parse(response.body).length
  end

  test "should show detailed player stats" do
    zezin = players(:zezin)
    chiquin = players(:chiquin)
    toin = players(:toin)
    manezin = players(:manezin)

    Kill.create!(killer: zezin, victim: chiquin, method: "sword")
    Kill.create!(killer: zezin, victim: toin, method: "bow")

    Kill.create!(killer: manezin, victim: zezin, method: "axe")
    Kill.create!(killer: manezin, victim: zezin, method: "axe")
    Kill.create!(killer: toin, victim: zezin, method: "spell")

    ItemPickup.create!(player: zezin, item_name: "Sword", quantity: 1)
    ItemPickup.create!(player: zezin, item_name: "Potion", quantity: 15)

    QuestStart.create!(player: zezin, quest_id: "q1", quest_name: "Slay the Dragon")
    QuestStart.create!(player: zezin, quest_id: "q2", quest_name: "Find the Lost Amulet")
    QuestCompletion.create!(player: zezin, quest_id: "q1", xp_gained: 1000, gold_gained: 500)

    BossKill.create!(player: zezin, boss_name: "Medusa", xp_gained: 1000, gold_gained: 500)
    BossKill.create!(player: zezin, boss_name: "Dragon", xp_gained: 2000, gold_gained: 1000)

    zezin.update!(gold: 1500, xp: 3000)

    get stats_api_v1_player_url(zezin)
    assert_response :success

    stats = JSON.parse(response.body)

    assert_equal zezin.id, stats["player_id"]
    assert_equal "Zezin", stats["name"]
    assert_equal 1500, stats["gold"]
    assert_equal 3000, stats["xp"]
    assert_equal 2, stats["kills"]
    assert_equal 3, stats["deaths"]
    assert_equal 16, stats["items_collected"]
    assert_equal 1, stats["quests_completed"]
    assert_equal 2, stats["quests_started"]
    assert_equal [ "Dragon", "Medusa" ].sort, stats["bosses_killed_names"].sort
    assert_equal [ "Potion", "Sword" ].sort, stats["collected_item_names"].sort
    assert_equal [ "Chiquin", "Toin" ].sort, stats["killed_player_names"].sort
    assert_equal "Manezin", stats["nemesis"]
  end

  test "should return 404 if player not found" do
    get stats_api_v1_player_url(id: "nonexistent")

    assert_response :not_found
    assert_equal({ "error" => "Player not found" }, JSON.parse(response.body))
  end
end
