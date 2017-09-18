require 'geo_location/version'
require 'geo_location/query'
require 'geo_location/ip_address'
require 'geo_location/models/location.rb'

module GeoLocation

  def self.search(query)
    query = GeoLocation::Query.new(query) unless query.is_a?(GeoLocation::Query)
    query.execute
  end
end

# load Railtie if Rails exists
if defined?(Rails)
  require 'geo_location/railtie'
end
