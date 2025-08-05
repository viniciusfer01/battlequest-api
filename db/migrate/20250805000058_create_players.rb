class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end
end
