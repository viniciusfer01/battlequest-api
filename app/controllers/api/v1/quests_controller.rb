class Api::V1::QuestsController < ApplicationController
  before_action :set_player

  def started
    limit = params.fetch(:limit, 50).to_i
    @quests = @player.quest_starts.order(created_at: :desc).limit(limit)
    render json: @quests
  end

  def completed
    limit = params.fetch(:limit, 50).to_i
    @quests = @player.quest_completions.order(created_at: :desc).limit(limit)
    render json: @quests
  end

  private

  def set_player
    @player = Player.find(params[:player_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Player not found" }, status: :not_found
  end
end
