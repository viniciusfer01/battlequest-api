require "test_helper"

class GameEventTest < ActiveSupport::TestCase
  test "invalid without raw_event" do
    game_event = GameEvent.new(event_type: "test", event_timestamp: Time.now)
    assert_not game_event.valid?
    assert_includes game_event.errors[:raw_event], "can't be blank"
  end

  test "invalid without event_type" do
    game_event = GameEvent.new(raw_event: "test", event_timestamp: Time.now)
    assert_not game_event.valid?
    assert_includes game_event.errors[:event_type], "can't be blank"
  end

  test "invalid without event_timestamp" do
    game_event = GameEvent.new(raw_event: "test", event_type: "test")
    assert_not game_event.valid?
    assert_includes game_event.errors[:event_timestamp], "can't be blank"
  end
end
