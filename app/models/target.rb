class Target < ApplicationRecord
  belongs_to :observation_planning
  belongs_to :celestial_body
end
