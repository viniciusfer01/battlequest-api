require "test_helper"

class Api::V1::ChatControllerTest < ActionDispatch::IntegrationTest
  setup do
    ChatMessage.delete_all
    @player = players(:zezin)

    # Create test data
    ChatMessage.create!(message_type: "chat", player: @player, content: "Hello world", event_timestamp: 2.days.ago)
    ChatMessage.create!(message_type: "announcement", content: "Server restarting soon", event_timestamp: 1.day.ago)
    ChatMessage.create!(message_type: "chat", player: @player, content: "GG", event_timestamp: Time.zone.now)
    ChatMessage.create!(message_type: "chat", player: @player, content: "Old message", event_timestamp: 10.days.ago)
    ChatMessage.create!(message_type: "announcement", content: "Welcome to the server", event_timestamp: 5.days.ago)
  end

  test "should get recent chat messages and announcements" do
    get api_v1_chat_index_url
    assert_response :success

    messages = JSON.parse(response.body)
    assert_equal 5, messages.size
    assert_equal "GG", messages.first["content"] # Most recent is first
  end

  test "should filter messages by start_time" do
    get api_v1_chat_index_url, params: { start_time: 90.minutes.ago.iso8601 }
    assert_response :success

    messages = JSON.parse(response.body)
    assert_equal 1, messages.size
    assert_equal "GG", messages.first["content"]
  end

  test "should filter messages by time interval" do
    get api_v1_chat_index_url, params: { start_time: 3.days.ago.iso8601, end_time: 1.hour.ago.iso8601 }
    assert_response :success

    messages = JSON.parse(response.body)
    assert_equal 2, messages.size
  end

  test "should respect the limit parameter" do
    get api_v1_chat_index_url, params: { limit: 1 }
    assert_response :success

    messages = JSON.parse(response.body)
    assert_equal 1, messages.size
  end
end
