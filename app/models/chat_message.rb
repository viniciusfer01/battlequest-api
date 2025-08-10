class ChatMessage < ApplicationRecord
  belongs_to :player, optional: true

  validates :message_type, presence: true, inclusion: { in: %w[chat announcement] }
  validates :content, presence: true
  validates :event_timestamp, presence: true

  validates :player, presence: true, if: :requires_player?

  private

  def requires_player?
    message_type == "chat"
  end
end
