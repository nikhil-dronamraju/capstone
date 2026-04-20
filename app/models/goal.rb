class Goal < ApplicationRecord
  belongs_to :milestone
  belongs_to :parent_goal, class_name: "Goal", optional: true, inverse_of: :child_goals
  has_many :todos, dependent: :destroy
  has_many :child_goals, class_name: "Goal", foreign_key: :parent_goal_id, dependent: :destroy, inverse_of: :parent_goal

  validates :name, presence: true
  validate :parent_goal_cannot_create_cycle
  validate :parent_goal_must_share_milestone

  def display_name
    label = name.presence || (id.present? ? "Goal ##{id}" : "New goal")
    [label, milestone&.display_name].compact.join(" - ")
  end

  private
    def parent_goal_cannot_create_cycle
      return if parent_goal.blank?

      if parent_goal == self
        errors.add(:parent_goal_id, "cannot be the same goal")
        return
      end

      ancestor = parent_goal
      while ancestor.present?
        if ancestor == self
          errors.add(:parent_goal_id, "cannot create a cycle")
          break
        end

        ancestor = ancestor.parent_goal
      end
    end

    def parent_goal_must_share_milestone
      return if parent_goal.blank? || milestone.blank?
      return if parent_goal.milestone_id == milestone_id

      errors.add(:parent_goal_id, "must belong to the same milestone")
    end
end
