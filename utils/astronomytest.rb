require 'astronomy'

# info = Astronomy::Information.new
# puts info.categories

# info = Astronomy::Information.new
# info.search 'moon'



def visible?(latitude, longitude, body, time)
  # Convertir les coordonnées GPS en radians
  lat = latitude * Math::PI / 180
  lon = longitude * Math::PI / 180

  # Calculer le temps universel (UTC)
  utc = time.utc

  # Calculer la position de l'astre
  pos = Astronomy::position(body, utc)

  # Calculer l'heure locale
  tz = TZInfo::Timezone.get('Europe/Paris')
  local_time = tz.utc_to_local(utc)

  # Calculer l'heure du lever et du coucher du soleil
  rise, set = Astronomy::sun_rise_set(local_time.year, local_time.month, local_time.day, lon, lat)

  # Vérifier si l'astre est au-dessus de l'horizon
  altitude = Astronomy::alt_az(pos[0], pos[1], utc, lon, lat)[0]
  altitude > 0 && local_time >= rise && local_time <= set
end

# Vérifier si Mars est visible depuis Paris à 21h le 9 mars 2023
latitude = 46
longitude = 6
info = Astronomy::Information.new
body = info.search 'Moon'
time = Time.new(2023, 3, 9, 21, 0, 0, "+01:00")

if visible?(latitude, longitude, body, time)
  puts "Mars est visible dans le ciel à cette heure."
else
  puts "Mars n'est pas visible dans le ciel à cette heure."
end
