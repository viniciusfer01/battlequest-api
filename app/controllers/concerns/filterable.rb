module Filterable
  extend ActiveSupport::Concern

  included do
    private

    def apply_filters(scope, filters)
      filters.each do |key, value|
        next if value.blank?

        scope = case key.to_sym
        when :name
                  scope.where("name LIKE ?", "%#{value}%")
        when :min_xp
                  scope.where("xp >= ?", value)
        when :max_xp
                  scope.where("xp <= ?", value)
        when :min_score
                  scope.where("score >= ?", value)
        when :max_score
                  scope.where("score <= ?", value)
        when :min_kills
                  scope.joins(:kills).group("players.id").having("COUNT(kills.id) >= ?", value)
        when :max_kills
                  scope.joins(:kills).group("players.id").having("COUNT(kills.id) <= ?", value)
        when :min_gold
                  scope.where("gold >= ?", value)
        when :max_gold
                  scope.where("gold <= ?", value)
        when :gt
                  scope.having("total_quantity > ?", value)
        when :gte
                  scope.having("total_quantity >= ?", value)
        when :lt
                  scope.having("total_quantity < ?", value)
        when :lte
                  scope.having("total_quantity <= ?", value)
        when :eq
                  scope.having("total_quantity = ?", value)
        else
                  scope
        end
      end
      scope
    end
  end
end
