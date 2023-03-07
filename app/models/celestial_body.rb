class CelestialBody < ApplicationRecord
  has_many :targets
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :RA, presence: true
  validates :DEC, presence: true
end
