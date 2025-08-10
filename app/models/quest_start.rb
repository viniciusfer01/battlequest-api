class QuestStart < ApplicationRecord
  belongs_to :player
  validates :player, presence: true
  validates :quest_id, presence: true
  validates :quest_name, presence: true
end
