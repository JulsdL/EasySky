require "json"
require "httparty"
require "tzinfo"
require "timezone"
require "date"

class ObservationPlanning < ApplicationRecord
  belongs_to :user
  has_many :targets

  has_many :celestial_bodies, through: :targets

  serialize :visible_objects, JSON

  validates :name, presence: true
  validates_time :start_time, presence: true
  validates_time :end_time, after: :start_time, presence: true

  # Convert a decimal number representing hours to hours, minutes, and seconds
  def decimal_to_hms(decimal)
    hours = decimal.to_i
    minutes = ((decimal - hours) * 60).to_i
    seconds = (((decimal - hours) * 60) - minutes) * 60
    return hours, minutes, seconds
  end

  # Retourne le décalage horaire en heure entre l'heure locale et l'heure UTC pour la position de l'observateur
  def utc_offset
    coordinates = [user.latitude, user.longitude]
    # find the user last booking date
    date = user.bookings.last.date

    timezone = Timezone.lookup(*coordinates)

    if timezone
      tz = TZInfo::Timezone.get(timezone.name)
      offset_seconds = tz.period_for_local(date).utc_total_offset # Récupère l'offset en secondes
      offset_hours = offset_seconds / 3600.0 # Convertit les secondes en heures
    else
      offset_hours = 0 # Utilise UTC par défaut si le fuseau horaire ne peut pas être déterminé
    end

    offset_hours
  end


  # Find astronomical objects visible above the horizon from the observer's location at a given time
  def select_objects
    observer_latitude = user.latitude # Latitude of observer in decimal degrees
    observer_longitude = user.longitude # Longitude of observer in decimal degrees
    observation_start_utc = start_time - utc_offset.hours # Start time of observation in UTC
    lst = local_sidereal_time(observer_longitude, observation_start_utc) # Local sidereal time at start of observation
    objects = load_objects_from_file('db/catalogue-de-messier.json') # Load astronomical objects from a file
    selected_objects = [] # Initialize an empty array to store visible objects

    # For each object, calculate its altitude and azimuth and add it to the selected_objects array if it is visible
    objects.each do |object|
      ra, dec = parse_ra_and_dec(object) # Extract right ascension and declination from object data
      altitude, azimuth = calculate_altitude_and_azimuth(ra, dec, lst, observer_latitude, observer_longitude) # Calculate altitude and azimuth of object at start of observation

      if altitude > 20 # If the object is above the horizon, add it to the selected_objects array with its altitude and azimuth
        selected_objects << object.merge(altitude: altitude, azimuth: azimuth)
      end
    end
    # Trie selected_objects par ordre décroissant de leur altitude
    sorted_objects = selected_objects.sort_by { |obj| -obj[:altitude] }
    # Sauvegarde les objets visibles dans la base de données
    self.visible_objects = sorted_objects.to_json

    return sorted_objects # Return the array of visible objects
  end

  # Calculate the local sidereal time at a given location and time
  def local_sidereal_time(observer_longitude, observation_start_utc)
    j2000 = Time.utc(2000, 1, 1, 12, 0, 0).to_i # Julian date of J2000.0 epoch
    days_since_j2000 = (observation_start_utc.to_f - j2000) / 86_400 # Number of days since J2000.0 epoch
    (100.46 + (0.985647 * days_since_j2000) + observer_longitude + (15 * utc_offset)) % 360 # Calculate the local sidereal time in degrees
  end

  # Load astronomical objects from a JSON file
  def load_objects_from_file(file_path)
    json_file = File.read(file_path) # Read the contents of the file as a string
    JSON.parse(json_file) # Parse the string as a JSON object
  end

  # Convert right ascension and declination from hours/degrees, minutes, and seconds to decimal degrees
  def parse_ra_and_dec(object)
    ra_hours, ra_minutes, ra_seconds = object['ra'].split(':').map(&:to_f) # Split right ascension into hours, minutes, and seconds
    ra = (hms_to_decimal(ra_hours, ra_minutes, ra_seconds) * 360) / 24 # Convert right ascension to decimal degrees
    dec_degrees, dec_minutes, dec_seconds = object['dec'].split(':').map(&:to_f) # Split declination into degrees, minutes, and seconds
    dec = dec_degrees + (dec_minutes / 60.0) + (dec_seconds / 3600.0) # Convert declination to decimal degrees

    return ra, dec
  end

  # Calculate object's altitude and azimuth at a given time and location
  def calculate_altitude_and_azimuth(ra, dec, lst, observer_latitude, _observer_longitude)
    ra_rad = ra * Math::PI / 180
    dec_rad = dec * Math::PI / 180
    lst_rad = lst * Math::PI / 180
    observer_latitude_rad = observer_latitude * Math::PI / 180

    object_altitude = Math.asin((Math.sin(dec_rad) * Math.sin(observer_latitude_rad)) + (Math.cos(dec_rad) * Math.cos(observer_latitude_rad) * Math.cos(lst_rad - ra_rad)))
    object_azimuth = Math.atan2(-Math.sin(lst_rad - ra_rad), (Math.tan(observer_latitude_rad) * Math.cos(dec_rad)) - (Math.sin(dec_rad) * Math.cos(lst_rad - ra_rad)))

    azimuth = ((object_azimuth * 180 / Math::PI) + 360) % 360 # Convert azimuth from radians to degrees
    altitude = object_altitude * 180 / Math::PI # Convert altitude from radians to degrees

    return altitude, azimuth
  end

  # Convert hours, minutes, and seconds to decimal hours
  def hms_to_decimal(hours, minutes, seconds)
    decimal = hours + (minutes / 60.0) + (seconds / 3600.0)
    return decimal
  end

  # call api to get sunrise and sunset infos for the latitude and longitude of User
  # and the date of the observation
  # date in format YYYY-MM-DD
  def sun(date)
    latitude = user.latitude
    longitude = user.longitude
    api_url = "https://api.sunrise-sunset.org/json?lat=#{latitude}&lng=#{longitude}&date=#{date}"

    response = HTTParty.get(api_url)
    json = JSON.parse(response.body)

    unformated_rise = DateTime.strptime(json['results']['nautical_twilight_begin'], "%H:%M:%S").to_time.utc
    local_sunrise = (unformated_rise + utc_offset.hours).strftime('%H:%M')
    unformated_set = DateTime.strptime(json['results']['nautical_twilight_end'], "%H:%M:%S").to_time.utc
    local_sunset = (unformated_set + utc_offset.hours).strftime('%H:%M')

    if local_sunrise.to_i > 12
      local_sunrise = (unformated_rise + utc_offset.hours - 12.hours).strftime('%H:%M')
    end

    if local_sunset.to_i < 12
      local_sunset = (unformated_set + utc_offset.hours + 12.hours).strftime('%H:%M')
    end

    self.sunrise = local_sunrise
    self.sunset = local_sunset
  end



  # call the api to get the moon phase for the date of the observation and rise/set time for user location
  def moon(date)
    application_id = '680ddb64-a69a-49e0-b03e-36b96b212227'
    application_secret = 'b847e997f20db4ddf0a840643c139a9e0145ba6e2c81888e27643657f7cde0132c1a11c79858fcd6611091705821e6058d8090656f992ce31bd29f2edd05416d6ff1e3405d89c1b12106db4b96c8dcd62fd37ab2eeb13ea47b82b2892d24c3ea185abd9aa1d7d7eeb0b82936c2e3a147'

    credentials = "#{application_id}:#{application_secret}"
    hash = Base64.strict_encode64(credentials)

    headers = {
      'Authorization' => "Basic #{hash}",
      'Content-Type' => 'application/json'
    }
    body = {
      format: 'svg',
      style: {
        moonStyle: 'default',
        backgroundStyle: 'stars',
        backgroundColor: 'black',
        headingColor: 'white',
        textColor: 'white'
      },
      observer: {
        latitude: user.latitude,
        longitude: user.longitude,
        date: date
      },
      view: {
        type: 'landscape-simple',
        orientation: 'north-up'
      }
    }
    response = HTTParty.post('https://api.astronomyapi.com/api/v2/studio/moon-phase', headers: headers, body: body.to_json)
    moon_phase_url = JSON.parse(response.body)['data']['imageUrl']
    self.moon_phase = moon_phase_url
  end
end
