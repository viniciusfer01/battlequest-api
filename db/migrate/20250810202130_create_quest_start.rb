class CreateQuestStart < ActiveRecord::Migration[8.0]
  def change
    create_table :quest_starts do |t|
      t.references :player, null: false, foreign_key: true
      t.string :quest_id, null: false
      t.string :quest_name, null: false

      t.timestamps
    end
  end
end
