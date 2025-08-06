require "test_helper"

class Api::V1::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_dashboard_index_url
    assert_response :success

    dashboard_data = JSON.parse(response.body)

    expected_data = { "active_players"=>4, "total_score"=>33,
                      "top_items"=>{ "health_potion"=>15,
                                     "mana_potion"=>6,
                                     "sword"=>1 },
                      "top_killers"=>[ { "player_id"=>1055619445, "player_name"=>"Zezin", "kills"=>2 },
                                       { "player_id"=>413661309, "player_name"=>"Toin", "kills"=>1 },
                                       { "player_id"=>420254097, "player_name"=>"Manezin", "kills"=>1 } ],
                      "bosses_defeated"=>{ "Dragon"=>1, "Kraken"=>1, "Medusa"=>2 },
                      "completed_quests"=>{ "q1"=>3, "q2"=>2, "q3"=>2 } }

    assert dashboard_data.key?("active_players")
    assert dashboard_data.key?("total_score")
    assert dashboard_data.key?("top_items")
    assert dashboard_data.key?("top_killers")
    assert dashboard_data.key?("bosses_defeated")
    assert dashboard_data.key?("completed_quests")
    assert_equal expected_data, dashboard_data
  end
end
