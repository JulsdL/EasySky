class AddVisibleObjectsToObservationPlannings < ActiveRecord::Migration[7.0]
  def change
    add_column :observation_plannings, :visible_objects, :text
  end
end
