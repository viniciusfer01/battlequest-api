class GameEvent < ApplicationRecord
  validates :raw_event, presence: true
  validates :event_type, presence: true
  validates :event_timestamp, presence: true
end
