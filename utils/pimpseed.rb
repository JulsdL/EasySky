require 'json'

file = File.read('db/catalogue-de-messier.json')
data = JSON.parse(file)
new_data = data.each do |celestial_body|
  celestial_body["description"] = ""
end

File.write('catalogue_messier_modifie.json', JSON.generate(data))
