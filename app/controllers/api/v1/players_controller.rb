class Api::V1::PlayersController < ApplicationController
  def index
    @players = Player.all
    render json: @players, status: :ok
  end

  def stats
    player = Player.find(params[:id])
    stats = {
      player_id: player.id,
      name: player.name,
      score: player.score,
      kills: Kill.where(killer_id: player.id).count,
      deaths: Kill.where(victim_id: player.id).count,
      items_collected: ItemPickup.where(player_id: player.id).sum(:quantity),
      quests_completed: QuestCompletion.where(player_id: player.id).count
    }

    render json: stats
  end
end
