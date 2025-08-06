class Api::V1::LeaderboardController < ApplicationController
  def index
    best_players = Player.order(score: :desc)
    @players = best_players.map do |player|
      {
        id: player.id,
        name: player.name,
        score: player.score
      }
    end
    render json: @players
  end
end
