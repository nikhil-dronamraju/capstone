class AddParentGoalToGoals < ActiveRecord::Migration[8.0]
  def change
    add_reference :goals, :parent_goal, foreign_key: { to_table: :goals }
  end
end
