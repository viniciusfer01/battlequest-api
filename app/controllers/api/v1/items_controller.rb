class Api::V1::ItemsController < ApplicationController
  def top
    items = ItemPickup.group(:item_name)
                      .select("item_name, SUM(quantity) as total_quantity")
                      .order("total_quantity DESC")

    items = apply_filters(items, params.slice(:name, :gt, :gte, :lt, :lte, :eq))
    items = paginate(items, default_per_page: 5, max_per_page: 100)

    render json: items
  end
end
