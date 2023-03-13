class AddMoonPhaseToObservationPlanning < ActiveRecord::Migration[7.0]
  def change
    add_column :observation_plannings, :moon_phase, :text
  end
end
