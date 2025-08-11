class Api::V1::LeaderboardController < ApplicationController
  def index
    leaderboard_type = params[:type]

    leaderboard = Player.all

    leaderboard = apply_filters(leaderboard, params.slice(:name, :min_xp, :max_xp, :min_score, :max_score, :min_kills, :max_kills, :min_gold, :max_gold))

    case leaderboard_type
    when "gold"
      leaderboard = leaderboard.order(gold: :desc)
      render_payload = leaderboard.select(:id, :name, :gold)
    when "xp"
      leaderboard = leaderboard.order(xp: :desc)
      render_payload = leaderboard.select(:id, :name, :xp)
    else
      leaderboard = leaderboard.order(score: :desc)
      render_payload = leaderboard.select(:id, :name, :score)
    end

    paginated_payload = paginate(render_payload, default_per_page: 5, max_per_page: 100)

    render json: paginated_payload
  end
end
