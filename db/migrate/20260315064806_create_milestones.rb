class CreateMilestones < ActiveRecord::Migration[8.0]
  def change
    create_table :milestones do |t|
      t.date :start_date
      t.date :end_date
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
