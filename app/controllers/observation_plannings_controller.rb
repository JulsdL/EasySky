class ObservationPlanningsController < ApplicationController
  def index
    @observation_plannings = current_user.observation_plannings
  end

  def show
    @observation_planning = ObservationPlanning.find(params[:id])
    @visible_objects = @observation_planning.visible_objects
  end
end
