class Booking < ApplicationRecord
  validates :zip, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :price, presence: true, numericality: true
  validates :date, presence: true
  validates :status, presence: true
  enum status: { pending: 0, confirmed: 1, canceled: 2 }

  belongs_to :user
  has_many :booking_items
  has_many :items, through: :booking_items
end
