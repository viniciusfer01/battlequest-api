class Api::V1::PlayersController < ApplicationController
  def index
    players = Player.all
    players = apply_filters(players, params.slice(:name, :min_xp, :max_xp, :min_score, :max_score, :min_kills, :max_kills, :min_gold, :max_gold))
    players = paginate(players, default_per_page: 5, max_per_page: 100)
    players = players.select(:id, :name, :score, :gold, :xp)

    render json: players, status: :ok
  end

  def stats
    player = Player.find(params[:id])

    # Calculate the player's nemesis (the one who killed them the most)
    nemesis_data = player.deaths.group(:killer_id).count.max_by { |_, count| count }
    nemesis_name = nemesis_data ? Player.find(nemesis_data.first).name : "None"

    stats = {
      player_id: player.id,
      name: player.name,
      score: player.score,
      gold: player.gold,
      xp: player.xp,
      kills: player.kills.count,
      deaths: player.deaths.count,
      items_collected: player.item_pickups.sum(:quantity),
      bosses_killed_names: player.boss_kills.pluck(:boss_name).uniq,
      collected_item_names: player.item_pickups.pluck(:item_name).uniq,
      quests_started: player.quest_starts.count,
      started_quest_names: player.quest_starts.pluck(:quest_name).uniq,
      quests_completed: player.quest_completions.count,
      finished_quest_names: player.quest_completions.pluck(:quest_id).uniq,
      killed_player_names: Player.where(id: player.kills.pluck(:victim_id)).pluck(:name),
      nemesis: nemesis_name
    }

    render json: stats
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Player not found" }, status: :not_found
  end
end
