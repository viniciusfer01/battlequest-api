class CreateBossKills < ActiveRecord::Migration[8.0]
  def change
    create_table :boss_kills do |t|
      t.references :player, null: false, foreign_key: true
      t.string :boss_name, null: false
      t.integer :xp_gained, null: false
      t.integer :gold_gained, null: false

      t.timestamps
    end
  end
end
