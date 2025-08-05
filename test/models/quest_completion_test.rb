require "test_helper"

class QuestCompletionTest < ActiveSupport::TestCase
  test "Valid quest completion" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, quest_id: "quest_1", xp_gained: 100, gold_gained: 50)
    assert quest_completion.valid?
  end

  test "Invalid without player" do
    quest_completion = QuestCompletion.new(quest_id: "quest_1", xp_gained: 100, gold_gained: 50)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:player], "must exist"
  end

  test "Invalid without quest_id" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, xp_gained: 100, gold_gained: 50)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:quest_id], "can't be blank"
  end

  test "Invalid without xp_gained" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, quest_id: "quest_1", gold_gained: 50)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:xp_gained], "can't be blank"
  end

  test "Invalid without gold_gained" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, quest_id: "quest_1", xp_gained: 100)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:gold_gained], "can't be blank"
  end

  test "Invalid with negative xp_gained" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, quest_id: "quest_1", xp_gained: -10, gold_gained: 50)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:xp_gained], "must be greater than or equal to 0"
  end

  test "Invalid with negative gold_gained" do
    player = Player.create(name: "Player1")
    quest_completion = QuestCompletion.new(player: player, quest_id: "quest_1", xp_gained: 100, gold_gained: -20)
    assert_not quest_completion.valid?
    assert_includes quest_completion.errors[:gold_gained], "must be greater than or equal to 0"
  end
end
