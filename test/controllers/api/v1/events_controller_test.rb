require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should receive 50 events when per_page is 50" do
    oldest_event = game_events(:event_1)

    get api_v1_events_url, params: { per_page: 50 }

    assert_response :success
    events_from_response = JSON.parse(response.body)
    assert_equal 50, events_from_response.length

    raw_events_from_response = events_from_response.map { |event| event["raw_event"] }

    assert_not_includes raw_events_from_response, oldest_event.raw_event
  end

  test "should respect a custom per_page parameter" do
    custom_per_page = 10

    get api_v1_events_url, params: { per_page: custom_per_page }

    assert_response :success

    events_from_response = JSON.parse(response.body)
    assert_equal custom_per_page, events_from_response.length
  end

  test "should default to 25 events when no parameter is given" do
    get api_v1_events_url
    assert_response :success

    events_from_response = JSON.parse(response.body)
    assert_equal 25, events_from_response.length
  end
end
