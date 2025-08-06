class Api::V1::ItemsController < ApplicationController
  def top
    items = ItemPickup.order(quantity: :desc).limit(10)
    render json: items.map { |item| { id: item.id, item_name: item.item_name, quantity: item.quantity } }
  end
end
