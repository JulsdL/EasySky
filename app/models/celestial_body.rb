class CelestialBody < ApplicationRecord
  has_many :targets
  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :ra, presence: true
  validates :dec, presence: true

  def self.orientation(degree)
    case degree
    when 22.5..67.5
      return 'NE'
    when 67.5..112.5
      return 'E'
    when 112.5..157.5
      return 'SE'
    when 157.5..202.5
      return 'S'
    when 202.5..247.5
      return 'SO'
    when 247.5..292.5
      return 'O'
    when 292.5..337
      return 'NO'
    else
      return 'N'
    end
  end
end
