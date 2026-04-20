class MilestonesController < ApplicationController
  before_action :set_milestone, only: %i[ update destroy ]

  def create
    @milestone = Milestone.new(milestone_params)

    if @milestone.save
      load_planner_data
      render turbo_stream: planner_streams(reset_milestone_form: true)
    else
      head :unprocessable_entity
    end
  end

  def update
    if @milestone.update(milestone_params)
      load_planner_data
      render turbo_stream: planner_streams
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @milestone.destroy!
    load_planner_data
    render turbo_stream: planner_streams(reset_milestone_form: true)
  end

  private
    def set_milestone
      @milestone = Milestone.find(params.expect(:id))
    end

    def milestone_params
      params.expect(milestone: [ :name, :start_date, :end_date ])
    end
end
