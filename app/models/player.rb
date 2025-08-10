class Player < ApplicationRecord
  has_many :quest_starts
  has_many :quest_completions
  has_many :kills, foreign_key: "killer_id", dependent: :destroy
  has_many :deaths, class_name: "Kill", foreign_key: "victim_id", dependent: :destroy
  has_many :item_pickups
  has_many :boss_kills

  validates :name, presence: true
  validates :score, presence: true, numericality: { only_integer: true }

  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.score ||= 0
    self.gold ||= 0
    self.xp ||= 0
  end
end
