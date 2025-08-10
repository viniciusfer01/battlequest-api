class Api::V1::LeaderboardController < ApplicationController
  def index
    leaderboard_type = params[:type]

    case leaderboard_type
    when "gold"
      @players = Player.order(gold: :desc).limit(100)
      render json: @players.select(:id, :name, :gold)
    when "xp"
      @players = Player.order(xp: :desc).limit(100)
      render json: @players.select(:id, :name, :xp)
    else # Default to score-based leaderboard
      @players = Player.order(score: :desc).limit(100)
      render json: @players.select(:id, :name, :score)
    end
  end
end
