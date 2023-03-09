class ObservationPlanning < ApplicationRecord
  belongs_to :user
  has_many :targets

  has_many :celestial_body, through: :targets

  validates :name, presence: true
  validates_time :start_time, presence: true
  validates_time :end_time, after: :start_time, presence: true

  def index
    @observation_plannings = ObservationPlanning.where(user: current_user)
  end
end
