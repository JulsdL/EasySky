class ObservationPlanningsController < ApplicationController
  def index
    @observation_plannings = current_user.observation_plannings
  end

  def show
    @observation_planning = ObservationPlanning.find(params[:id])
  end
end
