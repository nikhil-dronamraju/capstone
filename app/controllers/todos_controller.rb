class TodosController < ApplicationController
  before_action :set_todo, only: %i[ update destroy ]

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      load_planner_data
      render turbo_stream: planner_streams
    else
      head :unprocessable_entity
    end
  end

  def update
    if @todo.update(todo_params)
      load_planner_data
      render turbo_stream: planner_streams
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy!
    load_planner_data
    render turbo_stream: planner_streams
  end

  private
    def set_todo
      @todo = Todo.includes(goal: :milestone).find(params.expect(:id))
    end

    def todo_params
      params.expect(todo: [ :name, :start_date, :end_date, :goal_id ])
    end
end
