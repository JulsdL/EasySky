class CreateTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :targets do |t|
      t.references :observation_planning, null: false, foreign_key: true
      t.references :celestial_body, null: false, foreign_key: true

      t.timestamps
    end
  end
end
