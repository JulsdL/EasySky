class AddLocationToObservationPlannings < ActiveRecord::Migration[7.0]
  def change
    add_column :observation_plannings, :location, :string
  end
end
