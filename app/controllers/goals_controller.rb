class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ update destroy ]

  def create
    @goal = Goal.new(goal_params)

    if @goal.save
      load_planner_data
      render turbo_stream: planner_streams
    else
      head :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      load_planner_data
      render turbo_stream: planner_streams
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy!
    load_planner_data
    render turbo_stream: planner_streams
  end

  private
    def set_goal
      @goal = Goal.includes(:milestone, :parent_goal, :child_goals).find(params.expect(:id))
    end

    def goal_params
      params.expect(goal: [ :name, :start_date, :end_date, :milestone_id, :parent_goal_id ])
    end
end
