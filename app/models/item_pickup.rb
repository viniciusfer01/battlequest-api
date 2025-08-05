class ItemPickup < ApplicationRecord
  belongs_to :player
  validates :player, presence: true
  validates :item_name, presence: true
  validates :quantity, presence: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
