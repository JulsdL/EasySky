require 'httparty'
require 'base64'

# Replace <applicationId> and <applicationSecret> with your actual values
application_id = '680ddb64-a69a-49e0-b03e-36b96b212227'
application_secret = 'b847e997f20db4ddf0a840643c139a9e0145ba6e2c81888e27643657f7cde0132c1a11c79858fcd6611091705821e6058d8090656f992ce31bd29f2edd05416d6ff1e3405d89c1b12106db4b96c8dcd62fd37ab2eeb13ea47b82b2892d24c3ea185abd9aa1d7d7eeb0b82936c2e3a147'

# Encode the credentials as base64
credentials = "#{application_id}:#{application_secret}"
hash = Base64.strict_encode64(credentials)

# Set up the request headers
headers = {
  'Authorization' => "Basic #{hash}",
  'Content-Type' => 'application/json'
}

# Set up the request body
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
    latitude: 6.56774,
    longitude: 79.88956,
    date: '2023-03-13'
  },
  view: {
    type: 'landscape-simple',
    orientation: 'north-up'
  }
}

# Send the request and print the response
response = HTTParty.post('https://api.astronomyapi.com/api/v2/studio/moon-phase', headers: headers, body: body.to_json)
moon_phase_url = JSON.parse(response.body)['data']['imageUrl']

puts moon_phase_url
