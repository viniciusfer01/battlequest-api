class CreateKills < ActiveRecord::Migration[8.0]
  def change
    create_table :kills do |t|
      t.references :killer, null: false, foreign_key: { to_table: :players }
      t.references :victim, null: false, foreign_key: { to_table: :players }
      t.string :method, null: false

      t.timestamps
    end
  end
end
