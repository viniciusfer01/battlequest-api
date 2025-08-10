class Api::V1::ChatController < ApplicationController
  def index
    messages = ChatMessage.order(event_timestamp: :desc)

    if params[:start_time].present?
      messages = messages.where("event_timestamp >= ?", Time.zone.parse(params[:start_time]))
    end

    if params[:end_time].present?
      messages = messages.where("event_timestamp <= ?", Time.zone.parse(params[:end_time]))
    end

    limit = params.fetch(:limit, 100).to_i
    @messages = messages.limit(limit)

    render json: @messages, include: { player: { only: :name } }
  end
end
