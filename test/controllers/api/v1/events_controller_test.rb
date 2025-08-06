require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should receive 50 events" do
    oldest_event = game_events(:event_1)

    get api_v1_events_index_url

    assert_response :success
    events_from_response = JSON.parse(response.body)
    assert_equal 50, events_from_response.length

    raw_events_from_response = events_from_response.map { |event| event["raw_event"] }

    assert_not_includes raw_events_from_response, oldest_event.raw_event
  end

  test "should respect a custom limit parameter" do
    custom_limit = 10

    get api_v1_events_index_url, params: { limit: custom_limit }

    assert_response :success

    events_from_response = JSON.parse(response.body)
    assert_equal custom_limit, events_from_response.length
  end
end
