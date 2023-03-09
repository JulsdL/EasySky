$tz = 1
$longitude = 6.59
$latitude = 46.53

def local_angle
$longitude / 360.0
end

time = Time.now.utc
$year = Time.now.year
$month = Time.now.month
$day = Time.now.day
$radians_multiplier = Math::PI / 180.0
$degrees_multiplier = 180.0 / Math::PI
require 'date'
def jpd_date
Date.new($year, $month, $day).jd
end
# Calculate current Julian Period Cycle
$jpd_2000 = 2451545.0
# http://maia.usno.navy.mil/ser7/deltat.data
jps_delta_time = 67.0258 / 86400.0
$ca = 0.00014 #jps_delta_time or 0.0009 adds too much time

def jpd_cycle
jpd_date - $jpd_2000
end

# Mean Solar Transit for your Local Hour Angle
def jpd_noon
$jpd_2000 + jpd_cycle - local_angle
end

# Solar Mean Anomaly

def mean_anomaly
(357.5291 + 0.98560028 * (jpd_noon - $jpd_2000)) % 360
end

include Math
# Equation of Center
def equation_of_center
1.9148 * sin(mean_anomaly * $radians_multiplier) +
0.0200 * sin(2.0 * mean_anomaly * $radians_multiplier) +
0.0003 * sin(3.0 * mean_anomaly * $radians_multiplier)
end

#............. lambda_periapsis..............
# An approximation of angle when earth is closest to sun in a new year.(about the
# 2nd or 3rd day) There are ways to avoid using it but since wikipedia does I will
# my calculations for @2012 see astro_dog/lib/ptime.rb
#............................................

$lambda_periapsis = 180.0 + 102.9372

def ecliptic_longitude
(mean_anomaly + equation_of_center + $lambda_periapsis) % 360
end

def j_eot
0.0053 * sin(mean_anomaly * $radians_multiplier) -
0.0069 * sin( 2.0 * ecliptic_longitude * $radians_multiplier)
end

def j_transit
jpd_noon + j_eot
end

def sine_declination
sin(ecliptic_longitude * $radians_multiplier) *
sin(23.436 * $radians_multiplier)
end

def declination
asin(sine_declination) * $degrees_multiplier
end

# Horizon Angle
# Horizon Angle is the angle between Sunrise to Transit or Transit to Sunset.

def cosine_omega
(sin(-0.8333 * $radians_multiplier) /
cos($latitude * $radians_multiplier) *
cos(declination * $radians_multiplier)) -
(sin($latitude * $radians_multiplier) *
sin(declination * $radians_multiplier) /
cos($latitude * $radians_multiplier) *
cos(declination * $radians_multiplier))
end
def hour_angle
acos(cosine_omega) * $degrees_multiplier
end

def j_set
j_transit + hour_angle / 360.0
end
def j_rise
j_transit - hour_angle / 360.0
end

def julian_period_day_fraction_to_time(jpd_time)
jpd_fraction = jpd_time -0.5 - Integer(jpd_time - 0.5)
fraction = (jpd_fraction * 100000000.0).round / 100000000.0
hours = Integer(fraction * 24.0)
minutes = Integer((fraction - hours / 24.0) * 1440.0)
seconds = Integer((fraction - hours / 24.0 - minutes / 1440.0) * 86400.0)
Time.new($year, $month, $day, hours, minutes, seconds) + $tz * 3600
end
# Output results ^D if in irb
text = <<HEREDOC
The current time UTC = #{time}
Current Julian Cycle = #{jpd_cycle}
Julian Mean Solar transit = #{jpd_noon}
Approximate Julian EOT = #{j_eot}
Julian True Solar transit = #{j_transit}
Julian Sunrise #{j_rise}
Julian Sunset #{j_set}
Local Mean Noon #{julian_period_day_fraction_to_time(jpd_noon)}
Local Noon #{julian_period_day_fraction_to_time(j_transit)}
Local Sunrise #{julian_period_day_fraction_to_time(j_rise)}
Local Sunset #{julian_period_day_fraction_to_time(j_set)}
HEREDOC
puts text
