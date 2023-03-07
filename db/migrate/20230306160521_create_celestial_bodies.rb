class CreateCelestialBodies < ActiveRecord::Migration[7.0]
  def change
    create_table :celestial_bodies do |t|
      t.string :name
      t.text :description
      t.string :ra
      t.string :dec
      t.text :photo

      t.timestamps
    end
  end
end
