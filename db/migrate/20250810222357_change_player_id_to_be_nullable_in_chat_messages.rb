class ChangePlayerIdToBeNullableInChatMessages < ActiveRecord::Migration[8.0]
  def change
    change_column_null :chat_messages, :player_id, true
  end
end
