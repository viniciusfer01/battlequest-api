class CreateQuestCompletions < ActiveRecord::Migration[8.0]
  def change
    create_table :quest_completions do |t|
      t.references :player, null: false, foreign_key: true
      t.string :quest_id, null: false
      t.integer :xp_gained, null: false
      t.integer :gold_gained, null: false

      t.timestamps
    end
  end
end
