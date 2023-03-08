# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "json"
require "open-uri"

# Clean the database
puts "Cleaning database..."
CelestialBody.destroy_all

# Create a seed for 10 celestial bodies from the JSON file catalogue-de-messier.json

file = File.read('db/catalogue-de-messier.json')
data = JSON.parse(file).take(10)
count = 0

data.each do |celestial_body|
  messier = CelestialBody.create(
    name: celestial_body['messier'],
    description: "Type: #{celestial_body['objet']} - Constellation: #{celestial_body['french_name_nom_francais']} - #{celestial_body['ngc']} - Distance: #{celestial_body['distance']}années lumières",
    ra: celestial_body['ra'],
    dec: celestial_body['dec']
  )
  # Attach a photo to the celestial body from the url provided in the JSON file
  file = URI.open(celestial_body['image'])
  messier.photo.attach(io: file, filename: messier.name, content_type: 'image/jpg')
  messier.save!
  count += 1

  puts "#{count}: Created #{messier.name}"
end

puts "Finished!"
