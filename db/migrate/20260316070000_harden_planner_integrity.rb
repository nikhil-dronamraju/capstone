class HardenPlannerIntegrity < ActiveRecord::Migration[8.0]
  class Milestone < ApplicationRecord
    self.table_name = "milestones"
  end

  class Goal < ApplicationRecord
    self.table_name = "goals"
  end

  class Todo < ApplicationRecord
    self.table_name = "todos"
  end

  def up
    backfill_blank_names(Milestone, "Milestone")
    backfill_blank_names(Goal, "Goal")
    backfill_blank_names(Todo, "Todo")

    change_column_null :milestones, :name, false
    change_column_null :goals, :name, false
    change_column_null :todos, :name, false

    remove_foreign_key :goals, :goals, column: :parent_goal_id
    add_foreign_key :goals, :goals, column: :parent_goal_id, on_delete: :cascade

    add_check_constraint :goals,
      "parent_goal_id IS NULL OR parent_goal_id <> id",
      name: "goals_parent_goal_not_self"
  end

  def down
    remove_check_constraint :goals, name: "goals_parent_goal_not_self"

    remove_foreign_key :goals, :goals, column: :parent_goal_id
    add_foreign_key :goals, :goals, column: :parent_goal_id

    change_column_null :todos, :name, true
    change_column_null :goals, :name, true
    change_column_null :milestones, :name, true
  end

  private
    def backfill_blank_names(model, prefix)
      model.reset_column_information

      model.where(name: [ nil, "" ]).find_each do |record|
        record.update_columns(name: "#{prefix} #{record.id}")
      end
    end
end
