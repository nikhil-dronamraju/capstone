class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
    def load_planner_data
      @milestones = Milestone.order(:start_date, :end_date, :id).to_a
      @goals = Goal.includes(:todos).order(:start_date, :end_date, :id).to_a
      @goals_by_parent = @goals.group_by(&:parent_goal_id)
      @goals_by_milestone = @goals.group_by(&:milestone_id)
      load_planner_focus
    end

    def planner_streams(reset_milestone_form: false)
      streams = [
        turbo_stream.replace("planner-stats", partial: "static/stats", locals: { milestones: @milestones, goals: @goals }),
        turbo_stream.replace("planner-board", partial: "static/board", locals: { milestones: @milestones, goals_by_parent: @goals_by_parent, goals_by_milestone: @goals_by_milestone })
      ]

      if reset_milestone_form
        streams << turbo_stream.replace("milestone_form", partial: "static/milestone_form", locals: { milestone: Milestone.new })
      end

      streams
    end

    def load_planner_focus
      @active_milestone = @milestones.find { |milestone| milestone.id == params[:milestone_id]&.to_i }
      @active_milestone ||= @milestones.first

      scoped_goals = @active_milestone.present? ? @goals_by_milestone.fetch(@active_milestone.id, []) : []
      @active_goal = scoped_goals.find { |goal| goal.id == params[:goal_id]&.to_i }

      if @active_goal.present?
        @goal_chain = []
        current_goal = @active_goal

        while current_goal.present?
          @goal_chain.unshift(current_goal)
          current_goal = current_goal.parent_goal
        end
      else
        @goal_chain = []
      end
    end
end
