class AddNameToMilestone < ActiveRecord::Migration[8.0]
  def change
    add_column :milestones, :name, :string
  end
end
