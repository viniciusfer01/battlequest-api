class AddGoldAndXpToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :gold, :integer, default: 0, null: false
    add_column :players, :xp, :integer, default: 0, null: false
  end
end
