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
  after_create :generate_observation_planning

  # create a new observation planning for each new booking
  def generate_observation_planning
    planning = ObservationPlanning.new
    # add 8 random celestial bodies to the observation planning
    8.times do
      planning.celestial_bodies << CelestialBody.all.sample
    end
    # add the booking user_id to the observation planning
    planning.user_id = user_id
    # the booking date is the observation planning date and start time is 20:00 and end time is 22:00
    planning.start_time = date + 20.hours
    planning.end_time = date + 22.hours
    planning.name = "Plan d'observation du #{date}"
    planning.save
  end

  private

  def calculate_price
    self.price = items.sum(&:price)
  end
end
