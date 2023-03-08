# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "json"
require "open-uri"
require "faker"

# Clean the database
puts "Cleaning database..."
Item.destroy_all
ObservationPlanning.destroy_all
Booking.destroy_all
CelestialBody.destroy_all
User.destroy_all


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

# Creating 5 users
count = 0

user = User.new(
    first_name: "Caroline",
    last_name:  "Schmidt",
    email:      "caroline.schmidt@gmail.com",
    password:   123456,
    street:     "Ch. des Carrels 16",
    city:      "Neuchâtel",
    zip:       "2000",
  )
user.save!
count += 1
puts "#{count}: Created #{user.first_name} #{user.last_name}"

user = User.new(
  first_name: "Olivier",
  last_name:  "Mathez",
  email:      "olivier.mathez@gmail.com",
  password:   123456,
  street:     "Rue de Lausanne 42",
  city:      "Renens",
  zip:       "1020",
)
user.save!
count += 1
puts "#{count}: Created #{user.first_name} #{user.last_name}"

user = User.new(
  first_name: "Sophie",
  last_name:  "Ales",
  email:      "sophie.ales@gmail.com",
  password:   123456,
  street:     "Höhewag 95",
  city:      "Interlaken",
  zip:       "3800",
)
user.save!
count += 1
puts "#{count}: Created #{user.first_name} #{user.last_name}"

user = User.new(
  first_name: "Paul",
  last_name:  "Da Costa",
  email:      "paul.dacosta@gmail.com",
  password:   123456,
  street:     "Falkenpl. 32",
  city:      "Bern",
  zip:       "3012",
)
user.save!
count += 1
puts "#{count}: Created #{user.first_name} #{user.last_name}"

user = User.new(
  first_name: "Karl",
  last_name:  "Meier",
  email:      "karl.meier@gmail.com",
  password:   123456,
  street:     "Rosengasse 81",
  city:      "Zürich",
  zip:       "8001",
)
user.save!
count += 1
puts "#{count}: Created #{user.first_name} #{user.last_name}"

puts "Finished creating users"

# Creating 3 items
count = 0

item =  Item.new(
  name: "Telescope",
  price: 150
)
item.save!
count += 1
puts "#{count}: Created #{item.name}"

item =  Item.new(
  name: "Animateur",
  price: 150
)
item.save!
count += 1
puts "#{count}: Created #{item.name}"

item =  Item.new(
  name: "Planétarium gonflable",
  price: 300
)
item.save!
count += 1
puts "#{count}: Created #{item.name}"

puts "Finished creating items"

# Creating 4 bookings

count = 0

booking = Booking.new(
  user_id:  User.first.id,
  date: Faker::Date.in_date_period,
  street: User.first.street,
  zip: User.first.zip,
  city: User.first.city,
  price: rand(150 || 300),
  status: Booking.statuses.keys.sample
)
booking.save!
count += 1
puts "#{count}: Created booking"

booking = Booking.new(
  user_id:  User.last.id,
  date: Faker::Date.in_date_period,
  street: User.last.street,
  zip: User.last.zip,
  city: User.last.city,
  price: 150,
  status: Booking.statuses.keys.sample
)
booking.save!
count += 1
puts "#{count}: Created booking"

booking = Booking.new(
  user_id: User.all.second.id,
  date: Faker::Date.in_date_period,
  street: User.all.second.street,
  zip: User.all.second.zip,
  city: User.all.second.city,
  price: 300,
  status: Booking.statuses.keys.sample
)
booking.save!
count += 1
puts "#{count}: Created booking"

booking = Booking.new(
  user_id:  User.all.second.id,
  date: Faker::Date.in_date_period,
  street: User.all.second.street,
  zip: User.all.second.zip,
  city: User.all.second.city,
  price: 150,
  status: Booking.statuses.keys.sample
)
booking.save!
count += 1
puts "#{count}: Created booking"

puts "Finished creating bookings"

# Creating 4 plannings

planning = ObservationPlanning.new(
  name: "Soirée du 07/03/2022",
  start_time: Time.new(2022, 03, 07, 21, 00, 00),
  end_time: Time.new(2022, 03, 07, 23, 30, 00),
  user_id: User.all.sample.id
)
planning.save!
count += 1
puts "#{count}: Created #{planning.name}"

planning = ObservationPlanning.new(
  name: "Soirée du 23/03/2022",
  start_time: Time.new(2022, 03, 23, 21, 30, 00),
  end_time: Time.new(2022, 03, 23, 23, 30, 00),
  user_id: User.all.sample.id
)
planning.save!
count += 1
puts "#{count}: Created #{planning.name}"

planning = ObservationPlanning.new(
  name: "Soirée du 10/04/2022",
  start_time: Time.new(2022, 04, 10, 21, 00, 00),
  end_time: Time.new(2022, 04, 10 , 23, 30, 00),
  user_id: User.all.sample.id
)
planning.save!
count += 1
puts "#{count}: Created #{planning.name}"

planning = ObservationPlanning.new(
  name: "Soirée du 12/04/2022",
  start_time: Time.new(2022, 04, 12, 21, 00, 00),
  end_time: Time.new(2022, 04, 12, 23, 15, 00),
  user_id: User.all.sample.id
)
planning.save!
count += 1
puts "#{count}: Created #{planning.name}"

puts "Finished creating observation"
