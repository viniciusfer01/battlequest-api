class QuestCompletion < ApplicationRecord
  belongs_to :player
  validates :player, presence: true
  validates :quest_id, presence: true
  validates :xp_gained, presence: true
  validates :gold_gained, presence: true
  validates :xp_gained, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :gold_gained, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
