class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.datetime :date
      t.string :street
      t.string :city
      t.integer :zip
      t.float :price
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
