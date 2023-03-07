class CreateBookingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_items do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
