class Kill < ApplicationRecord
  belongs_to :killer, class_name: "Player"
  belongs_to :victim, class_name: "Player"

  validates :killer, presence: true
  validates :victim, presence: true
  validates :method, presence: true
end
