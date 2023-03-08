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

# Create a seed to create selected number of celestial bodies from the JSON file catalogue-de-messier.json
puts "How many celestial bodies do you want to create (max 110)?"
print "> "
number = gets.chomp.to_i

puts "Creating #{number} celestial bodies..."
file = File.read('db/catalogue-de-messier.json')
data = JSON.parse(file).shuffle.take(number)
count = 0

data.each do |celestial_body|
  messier = CelestialBody.create(
    name: celestial_body['messier'],
    description: "Type: #{celestial_body['objet']} - Constellation: #{celestial_body['french_name_nom_francais']} - #{celestial_body['ngc']} - Distance: #{celestial_body['distance']} années lumières",
    ra: celestial_body['ra'],
    dec: celestial_body['dec']
  )
# Browse all images in the folder db/images and attach them to the celestial body if the name of the image is the same as the name of the celestial body.
  Dir.glob("db/images/*").each do |image|
    if image.include?(messier.name)
      file = URI.open(image)
      messier.photo.attach(io: file, filename: messier.name, content_type: 'image/jpg')
    end
  end
  messier.save!
  count += 1

  puts "#{count}: Created #{messier.name}"
end

puts "Finished!"
