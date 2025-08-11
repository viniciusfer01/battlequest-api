require "test_helper"

class Api::V1::LeaderboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zezin = players(:zezin)
    @chiquin = players(:chiquin)
    @toin = players(:toin)
    @manezin = players(:manezin)
  end

  test "should rank players by score based on fixtures" do
    get api_v1_leaderboard_url
    assert_response :success

    leaderboard = JSON.parse(response.body)

    ranked_names = leaderboard.map { |p| p["name"] }

    expected_order = [ @manezin.name, @toin.name, @chiquin.name, @zezin.name ]

    assert_equal expected_order, ranked_names
    assert leaderboard.first.key?("score")
  end

  test "should rank players by gold" do
    @manezin.update!(gold: 100)
    @zezin.update!(gold: 500)
    @chiquin.update!(gold: 200)
    @toin.update!(gold: 50)

    get "/api/v1/leaderboard/gold"
    assert_response :success

    leaderboard = JSON.parse(response.body)
    ranked_names = leaderboard.map { |p| p["name"] }

    expected_order = [ @zezin.name, @chiquin.name, @manezin.name, @toin.name ]

    assert_equal expected_order, ranked_names
    assert leaderboard.first.key?("gold")
  end

  test "should rank players by xp" do
    @toin.update!(xp: 2000)
    @manezin.update!(xp: 1500)
    @zezin.update!(xp: 1000)
    @chiquin.update!(xp: 500)

    get "/api/v1/leaderboard/xp"
    assert_response :success

    leaderboard = JSON.parse(response.body)
    ranked_names = leaderboard.map { |p| p["name"] }

    expected_order = [ @toin.name, @manezin.name, @zezin.name, @chiquin.name ]

    assert_equal expected_order, ranked_names
    assert leaderboard.first.key?("xp")
  end

  test "should apply score filter to leaderboard" do
    get api_v1_leaderboard_url, params: { min_score: 10 }
    assert_response :success

    leaderboard = JSON.parse(response.body)

    assert_equal 2, leaderboard.size
    assert leaderboard.all? { |p| p["score"] >= 10 }

    ranked_names = leaderboard.map { |p| p["name"] }
    expected_order = [ @manezin.name, @toin.name ]
    assert_equal expected_order, ranked_names
  end

  test "should apply gold filter to leaderboard" do
    @manezin.update!(gold: 100)
    @chiquin.update!(gold: 200)
    @zezin.update!(gold: 500)
    @toin.update!(gold: 50)

    get api_v1_leaderboard_url, params: { min_gold: 100 }
    assert_response :success

    leaderboard = JSON.parse(response.body)

    assert_equal 3, leaderboard.size
    assert_equal @manezin.name, leaderboard.first["name"]
    assert_equal @chiquin.name, leaderboard.second["name"]
    assert_equal @zezin.name, leaderboard.last["name"]
  end
end
