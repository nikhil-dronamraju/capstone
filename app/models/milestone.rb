class Milestone < ApplicationRecord
  has_many :goals, dependent: :destroy
  has_many :root_goals, -> { where(parent_goal_id: nil) }, class_name: "Goal", inverse_of: :milestone

  validates :name, presence: true

  def display_name
    name.presence || "Milestone ##{id}"
  end
end
