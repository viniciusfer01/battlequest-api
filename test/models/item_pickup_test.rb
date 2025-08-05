require "test_helper"

class ItemPickupTest < ActiveSupport::TestCase
  test "Valid item pickup" do
    player = Player.create(name: "Player1")
    item_pickup = ItemPickup.new(player: player, item_name: "Health Potion", quantity: 1)
    assert item_pickup.valid?
  end

  test "Invalid without player" do
    item_pickup = ItemPickup.new(item_name: "Health Potion", quantity: 1)
    assert_not item_pickup.valid?
    assert_includes item_pickup.errors[:player], "must exist"
  end

  test "Invalid without item_name" do
    player = Player.create(name: "Player1")
    item_pickup = ItemPickup.new(player: player, quantity: 1)
    assert_not item_pickup.valid?
    assert_includes item_pickup.errors[:item_name], "can't be blank"
  end

  test "Invalid without quantity" do
    player = Player.create(name: "Player1")
    item_pickup = ItemPickup.new(player: player, item_name: "Health Potion")
    assert_not item_pickup.valid?
    assert_includes item_pickup.errors[:quantity], "can't be blank"
  end

  test "Invalid with negative quantity" do
    player = Player.create(name: "Player1")
    item_pickup = ItemPickup.new(player: player, item_name: "Health Potion", quantity: -1)
    assert_not item_pickup.valid?
    assert_includes item_pickup.errors[:quantity], "must be greater than 0"
  end
end
