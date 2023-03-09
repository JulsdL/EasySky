class ObservationPlanning < ApplicationRecord
  belongs_to :user
  has_many :targets

  has_many :celestial_bodies, through: :targets

  validates :name, presence: true
  validates_time :start_time, presence: true
  validates_time :end_time, after: :start_time, presence: true
end
