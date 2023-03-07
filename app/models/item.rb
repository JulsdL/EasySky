class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: true
  has_many :booking_items
end
