# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_15_155211) do

  create_table "elos", force: :cascade do |t|
    t.float "value"
    t.integer "player_id"
    t.integer "match_id"
    t.string "saison"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_elos_on_match_id"
    t.index ["player_id"], name: "index_elos_on_player_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "sgtournoi_id"
    t.integer "sgevent_id"
    t.string "tournoi_name"
    t.date "tournoi_date"
    t.string "tournoi_place"
    t.integer "nb_participant"
    t.integer "nb_match"
    t.string "event_game"
    t.string "saison"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "player_1_id"
    t.integer "player_2_id"
    t.integer "event_id"
    t.boolean "result"
    t.integer "ordre"
    t.integer "phase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_matches_on_event_id"
    t.index ["player_1_id"], name: "index_matches_on_player_1_id"
    t.index ["player_2_id"], name: "index_matches_on_player_2_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "nickname"
    t.string "team"
    t.string "game"
    t.integer "nb_match_total"
    t.integer "nb_tournoi_total"
    t.integer "nb_match_saison"
    t.integer "nb_tournoi_saison"
    t.string "place"
    t.string "ranking_previous_pc"
    t.string "ranking_previous_ps4"
    t.string "saison_current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
