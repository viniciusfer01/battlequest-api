class Api::V1::EventsController < ApplicationController
  def index
    events = GameEvent.order(event_timestamp: :desc)
    events = paginate(events, default_per_page: 25, max_per_page: 200)

    render json: events
  end
end
