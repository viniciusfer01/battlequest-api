require "test_helper"

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get top items from fixtures, ordered by total quantity" do
    get api_v1_items_top_url
    assert_response :success

    items = JSON.parse(response.body)

    assert_equal 3, items.size

    assert items.all? { |item| item.key?("item_name") && item.key?("total_quantity") }

    assert_equal "health_potion", items.first["item_name"]
    assert_equal 15, items.first["total_quantity"]

    assert_equal "mana_potion", items[1]["item_name"]
    assert_equal 6, items[1]["total_quantity"]

    assert_equal "sword", items.last["item_name"]
    assert_equal 1, items.last["total_quantity"]
  end
end
