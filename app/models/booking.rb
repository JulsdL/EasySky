class Booking < ApplicationRecord
  validates :zip, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :price, presence: true, numericality: true
  validates :date, presence: true
  validates :status, presence: true
  enum status: { attente: 0, confirmé: 1, annulé: 2 }

  belongs_to :user
  has_many :booking_items
  has_many :items, through: :booking_items

  before_validation :calculate_price

  private

  def calculate_price
    self.price = items.sum(&:price)
  end
end
