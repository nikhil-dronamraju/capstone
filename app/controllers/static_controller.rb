class StaticController < ApplicationController
  def index
    load_planner_data
  end
end
