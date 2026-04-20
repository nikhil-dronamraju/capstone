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

ActiveRecord::Schema[8.0].define(version: 2026_03_16_070000) do
  create_table "goals", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "milestone_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_goal_id"
    t.string "name", null: false
    t.index ["milestone_id"], name: "index_goals_on_milestone_id"
    t.index ["parent_goal_id"], name: "index_goals_on_parent_goal_id"
    t.check_constraint "parent_goal_id IS NULL OR parent_goal_id <> id", name: "goals_parent_goal_not_self"
  end

  create_table "milestones", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
  end

  create_table "todos", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["goal_id"], name: "index_todos_on_goal_id"
  end

  add_foreign_key "goals", "goals", column: "parent_goal_id", on_delete: :cascade
  add_foreign_key "goals", "milestones"
  add_foreign_key "todos", "goals"
end
