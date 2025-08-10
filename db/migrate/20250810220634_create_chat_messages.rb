class CreateChatMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages do |t|
      t.references :player, null: false, foreign_key: true
      t.string :message_type, null: false
      t.text :content, null: false
      t.datetime :event_timestamp, null: false

      t.timestamps
    end
  end
end
