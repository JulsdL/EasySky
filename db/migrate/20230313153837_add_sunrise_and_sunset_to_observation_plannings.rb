class AddSunriseAndSunsetToObservationPlannings < ActiveRecord::Migration[7.0]
  def change
    add_column :observation_plannings, :sunrise, :string
    add_column :observation_plannings, :sunset, :string
  end
end
