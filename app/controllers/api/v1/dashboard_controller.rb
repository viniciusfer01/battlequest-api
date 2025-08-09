class Api::V1::DashboardController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate
  def index
    dashboard_data = {
      active_players: Player.count,
      total_score: Player.sum(:score),
      top_items: ItemPickup.group(:item_name).sum(:quantity).sort_by { |_, quantity| -quantity }.first(5).to_h,
      top_killers: Kill.group(:killer_id).count.sort_by { |_, count| -count }.first(5).map { |id, count| { player_id: id, player_name: Player.find(id).name, kills: count } },
      bosses_defeated: BossKill.group(:boss_name).count,
      completed_quests: QuestCompletion.group(:quest_id).count.transform_values { |count| count }
    }
    render json: dashboard_data
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ApiToken.find_each do |api_token|
        return true if ActiveSupport::SecurityUtils.secure_compare(api_token.token, token)
      end
      false
    end
  end
end
