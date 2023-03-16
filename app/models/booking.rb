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
    # add the booking user_id to the observation planning
    planning.user_id = user_id
    # add the booking location to the observation planning
    planning.location = city
    # call the sun method from the observation planning model to get the sunries and sunset time
    planning.sun(date.strftime("%y-%m-%d"))
    # the booking date is the observation planning date and start time is 20:00 and end time is 22:00
    planning.start_time = date + 20.hours
    planning.end_time = date + 22.hours
    planning.name = "Plan d'observation du #{date.strftime("%d.%m.%y")}"
    # add 8 celestial bodies to the observation planning, wich are the 8 first celestial bodies corresponding
    # to the ones returned by the visible_objects method
    planning.select_objects # call the select_objects method from the observation planning model
    planning.celestial_bodies = JSON.parse(planning.visible_objects).first(8).map { |object| CelestialBody.find_by!(name: object["messier"]) }
    # call the moon method from the observation planning model to get the moon_phase image url
    planning.moon(date.strftime("%Y-%m-%d"))
    planning.save
  end

  private

  def calculate_price
    self.price = items.sum(&:price)
  end
end
