require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "valid player" do
    player = Player.new(name: "Test Player", score: 100)
    assert player.valid?
  end

  test "invalid without name" do
    player = Player.new(score: 100)
    assert_not player.valid?
    assert_includes player.errors[:name], "can't be blank"
  end

  test "score defaults to zero" do
    player = Player.create(name: "Default Score Player")
    assert_equal 0, player.score
  end
end
