# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090620163359) do

  create_table "game_states", :force => true do |t|
    t.integer  "game_id"
    t.binary   "game_state"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "max_players",   :default => 4
    t.text     "comment"
    t.integer  "game_state_id"
  end

  create_table "seatings", :force => true do |t|
    t.integer  "position"
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "users", :force => true do |t|
    t.string  "username"
    t.string  "email"
    t.string  "password"
    t.string  "actual_name"
    t.string  "identifier",         :limit => nil
    t.boolean "email_notification"
  end

end
