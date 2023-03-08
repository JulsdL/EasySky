class CelestialBodiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @celestial_bodies = CelestialBody.all
  end
end
