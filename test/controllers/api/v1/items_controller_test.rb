require "test_helper"

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should display top items" do
    get api_v1_items_top_url

    assert_response :success
    items_from_response = JSON.parse(response.body)
    assert_not_empty items_from_response
    assert items_from_response.all? { |item| item.key?("id") && item.key?("item_name") && item.key?("quantity") }
    assert_equal items_from_response, items_from_response.sort_by { |item| -item["quantity"] }

    assert_equal "health_potion", items_from_response.first["item_name"]
    assert_equal "mana_potion", items_from_response.second["item_name"]
    assert_equal "sword", items_from_response.third["item_name"]
  end
end
