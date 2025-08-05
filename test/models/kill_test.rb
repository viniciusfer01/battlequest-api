require "test_helper"

class KillTest < ActiveSupport::TestCase
  test "valid kill" do
    killer = Player.create(name: "Killer")
    victim = Player.create(name: "Victim")
    kill = Kill.new(killer: killer, victim: victim, method: "sword")
    assert kill.valid?
  end
  test "invalid without killer" do
    victim = Player.new(name: "Victim")
    kill = Kill.new(victim: victim, method: "sword")
    assert_not kill.valid?
    assert_includes kill.errors[:killer], "can't be blank"
  end

  test "invalid without victim" do
    kill = Kill.new(killer: Player.new, method: "sword")
    assert_not kill.valid?
    assert_includes kill.errors[:victim], "can't be blank"
  end

  test "invalid without method" do
    kill = Kill.new(killer: Player.new, victim: Player.new)
    assert_not kill.valid?
    assert_includes kill.errors[:method], "can't be blank"
  end
end
