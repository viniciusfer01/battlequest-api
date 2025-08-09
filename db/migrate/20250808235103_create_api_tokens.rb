class CreateApiTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :api_tokens do |t|
      t.string :token

      t.timestamps
    end
    add_index :api_tokens, :token
  end
end
