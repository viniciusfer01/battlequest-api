require "test_helper"

class QuestStartTest < ActiveSupport::TestCase
  test "Valid quest completion" do
    player = Player.create(name: "Player1")
    quest_start = QuestStart.new(player: player, quest_id: "quest_1", quest_name: "q1")
    assert quest_start.valid?
  end

  test "Invalid without player" do
    quest_start = QuestStart.new(quest_id: "quest_1", quest_name: "q1")
    assert_not quest_start.valid?
    assert_includes quest_start.errors[:player], "must exist"
  end

  test "Invalid without quest_id" do
    player = Player.create(name: "Player1")
    quest_start = QuestStart.new(player: player, quest_name: "q1")
    assert_not quest_start.valid?
    assert_includes quest_start.errors[:quest_id], "can't be blank"
  end

  test "Invalid without name" do
    player = Player.create(name: "Player1")
    quest_start = QuestStart.new(player: player, quest_id: "quest_1")
    assert_not quest_start.valid?
    assert_includes quest_start.errors[:quest_name], "can't be blank"
  end
end
