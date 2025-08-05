class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.text :raw_event, null: false
      t.string :event_type, null: false
      t.datetime :event_timestamp, null: false

      t.timestamps
    end
  end
end
