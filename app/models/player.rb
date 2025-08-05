class Player < ApplicationRecord
  validates :name, presence: true
  validates :score, presence: true, numericality: { only_integer: true }

  after_initialize :set_default_score, if: :new_record?

  private

  def set_default_score
    self.score ||= 0
  end
end
