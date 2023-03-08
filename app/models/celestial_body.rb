class CelestialBody < ApplicationRecord
  has_many :targets
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :ra, presence: true
  validates :dec, presence: true
end
