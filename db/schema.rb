# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_10_222357) do
  create_table "api_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token"
  end

  create_table "boss_kills", force: :cascade do |t|
    t.integer "player_id", null: false
    t.string "boss_name", null: false
    t.integer "xp_gained", null: false
    t.integer "gold_gained", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_boss_kills_on_player_id"
  end

  create_table "chat_messages", force: :cascade do |t|
    t.integer "player_id"
    t.string "message_type", null: false
    t.text "content", null: false
    t.datetime "event_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_chat_messages_on_player_id"
  end

  create_table "game_events", force: :cascade do |t|
    t.text "raw_event", null: false
    t.string "event_type", null: false
    t.datetime "event_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_pickups", force: :cascade do |t|
    t.integer "player_id", null: false
    t.string "item_name", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_item_pickups_on_player_id"
  end

  create_table "kills", force: :cascade do |t|
    t.integer "killer_id", null: false
    t.integer "victim_id", null: false
    t.string "method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["killer_id"], name: "index_kills_on_killer_id"
    t.index ["victim_id"], name: "index_kills_on_victim_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gold", default: 0, null: false
    t.integer "xp", default: 0, null: false
  end

  create_table "quest_completions", force: :cascade do |t|
    t.integer "player_id", null: false
    t.string "quest_id", null: false
    t.integer "xp_gained", null: false
    t.integer "gold_gained", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_quest_completions_on_player_id"
  end

  create_table "quest_starts", force: :cascade do |t|
    t.integer "player_id", null: false
    t.string "quest_id", null: false
    t.string "quest_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_quest_starts_on_player_id"
  end

  add_foreign_key "boss_kills", "players"
  add_foreign_key "chat_messages", "players"
  add_foreign_key "item_pickups", "players"
  add_foreign_key "kills", "players", column: "killer_id"
  add_foreign_key "kills", "players", column: "victim_id"
  add_foreign_key "quest_completions", "players"
  add_foreign_key "quest_starts", "players"
end
