class ObservationPlanningsController < ApplicationController
  def index
    @observation_plannings = current_user.observation_plannings.sort_by(&:start_time)
  end

  def show
    @observation_planning = ObservationPlanning.find(params[:id])
    @visible_objects = JSON.parse(@observation_planning.visible_objects)
  end
end
