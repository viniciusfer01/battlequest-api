require "test_helper"

class BossKillTest < ActiveSupport::TestCase
  test "Valid boss kill" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, boss_name: "Dragon", xp_gained: 500, gold_gained: 200)
    assert boss_kill.valid?
  end

  test "Invalid without player" do
    boss_kill = BossKill.new(boss_name: "Dragon", xp_gained: 500, gold_gained: 200)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:player], "must exist"
  end

  test "Invalid without boss_name" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, xp_gained: 500, gold_gained: 200)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:boss_name], "can't be blank"
  end

  test "Invalid without xp_gained" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, boss_name: "Dragon", gold_gained: 200)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:xp_gained], "can't be blank"
  end

  test "Invalid without gold_gained" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, boss_name: "Dragon", xp_gained: 500)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:gold_gained], "can't be blank"
  end

  test "Invalid with negative xp_gained" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, boss_name: "Dragon", xp_gained: -100, gold_gained: 200)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:xp_gained], "must be greater than or equal to 0"
  end

  test "Invalid with negative gold_gained" do
    player = Player.create(name: "Player1")
    boss_kill = BossKill.new(player: player, boss_name: "Dragon", xp_gained: 500, gold_gained: -200)
    assert_not boss_kill.valid?
    assert_includes boss_kill.errors[:gold_gained], "must be greater than or equal to 0"
  end
end
