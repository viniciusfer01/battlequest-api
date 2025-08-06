class Api::V1::EventsController < ApplicationController
  def index
    limit = params.fetch(:limit, 50).to_i
    @events = GameEvent.order(event_timestamp: :desc).limit(limit)
    render json: @events.select(:raw_event, :event_timestamp)
  end
end
