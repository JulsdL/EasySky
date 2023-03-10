def hms_to_decimal(hours, minutes, seconds)
  decimal = hours + minutes/60.0 + seconds/3600.0
  return decimal
end

# Définir les coordonnées de l'observateur
observer_latitude = 46.61 # Latitude en degrés
observer_longitude = 6.4 # Longitude en degrés

# Définir les coordonnées de l'objet en heures décimales et en degrés
object_ra = 23.934444 # Heure décimale de l'ascension droite
object_dec = -20.75 # Déclinaison en degrés

# Calculer l'heure sidérale locale pour une date et une heure données
days_since_j2000 = (Time.now.utc.to_f / 86_400) - 10957.5
utc_seconds = Time.now.utc.to_i % 86_400
lst = (100.46 + 0.985647 * days_since_j2000 + observer_longitude + 15 * (utc_seconds / 3600)) % 360

# Calculer les coordonnées horizontales de l'objet pour cette heure sidérale locale
object_altitude = Math.asin(Math.sin(object_dec * Math::PI / 180) * Math.sin(observer_latitude * Math::PI / 180) + Math.cos(object_dec * Math::PI / 180) * Math.cos(observer_latitude * Math::PI / 180) * Math.cos((lst - object_ra) * Math::PI / 180))
object_azimuth = Math.atan2(-Math.sin((lst - object_ra) * Math::PI / 180), Math.tan(observer_latitude * Math::PI / 180) * Math.cos(object_dec * Math::PI / 180) - Math.sin(object_dec * Math::PI / 180) * Math.cos((lst - object_ra) * Math::PI / 180))
azimuth = (object_azimuth * 180 / Math::PI + 360) % 360
altitude = object_altitude * 180 / Math::PI

puts "Azimuth: #{azimuth}, Altitude: #{altitude}"
