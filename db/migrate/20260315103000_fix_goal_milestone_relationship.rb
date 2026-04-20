class FixGoalMilestoneRelationship < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :milestones, :goals
    remove_column :milestones, :goal_id, :integer
  end
end
