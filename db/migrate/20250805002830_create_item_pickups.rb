class CreateItemPickups < ActiveRecord::Migration[8.0]
  def change
    create_table :item_pickups do |t|
      t.references :player, null: false, foreign_key: true
      t.string :item_name, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
