# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a seed for celestial_bodies from the JSON file catalogue-de-messier.json

require "json"
require "open-uri"

# Clean the database
puts "Cleaning database..."
CelestialBody.destroy_all

file = File.read("db/catalogue-de-messier.json")
data = JSON.parse(file)

data.each do |celestial_body|
  messier = CelestialBody.create(
    name: celestial_body["messier"],
    description: celestial_body["french_name_nom_français"],
    ra: celestial_body["ra"],
    dec: celestial_body["dec"]
  )
  # Attach a photo to the celestial body from the url provided in the JSON file
  file = URI.open(celestial_body["image"])
  messier.photo.attach(io: file, filename: "nes.png", content_type: "image/png")
  messier.save

  puts "Created #{messier.name}"
end
