module StaticHelper
  def milestone_total_todos(milestone, goals_by_milestone)
    goals_by_milestone.fetch(milestone.id, []).sum { |goal| goal.todos.size }
  end

  def goal_descendant_count(goal, goals_by_parent)
    children = goals_by_parent.fetch(goal.id, [])
    children.sum { |child| 1 + goal_descendant_count(child, goals_by_parent) }
  end

  def goal_date_range(goal)
    [goal.start_date, goal.end_date].compact.join(" -> ").presence || "No dates"
  end

  def milestone_date_range(milestone)
    [milestone.start_date, milestone.end_date].compact.join(" -> ").presence || "No dates"
  end

  def todo_date_range(todo)
    [todo.start_date, todo.end_date].compact.join(" -> ").presence || "No dates"
  end
end
