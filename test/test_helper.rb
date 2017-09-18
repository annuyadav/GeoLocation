# encoding: utf-8
require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'yaml'
configs = YAML.load_file('test/database.yml')

if configs.keys.include? ENV['DB']
  require 'active_record'

  # Establish a database connection
  ActiveRecord::Base.configurations = configs

  db_name = ENV['DB']
  if db_name == 'sqlite' && ENV['USE_SQLITE_EXT'] == '1' then
    gem 'sqlite_ext'
    require 'sqlite_ext'
    SqliteExt.register_ruby_math
  end
  ActiveRecord::Base.establish_connection(db_name.to_sym)
  ActiveRecord::Base.default_timezone = :utc

  ActiveRecord::Migrator.migrate('test/db/migrate', nil)
else
  class MysqlConnection
    def adapter_name
      "mysql"
    end
  end

  ##
  # Simulate enough of ActiveRecord::Base that objects can be used for testing.
  #
  module ActiveRecord
    class Base

      def initialize
        @attributes = {}
      end

      def read_attribute(attr_name)
        @attributes[attr_name.to_sym]
      end

      def write_attribute(attr_name, value)
        @attributes[attr_name.to_sym] = value
      end

      def update_attribute(attr_name, value)
        write_attribute(attr_name.to_sym, value)
      end

      def self.scope(*args); end

      def self.connection
        MysqlConnection.new
      end

      def method_missing(name, *args, &block)
        if name.to_s[-1..-1] == "="
          write_attribute name.to_s[0...-1], *args
        else
          read_attribute name
        end
      end

      class << self
        def table_name
          'test_table_name'
        end

        def primary_key
          :id
        end

        def maximum(_field)
          1.0
        end
      end
    end
  end
end

# simulate Rails module so Railtie gets loaded
module Rails
end

# Require Geocoder after ActiveRecord simulator.
require 'geo_location'

# and initialize Railtie manually (since Rails::Railtie doesn't exist)
Geocoder::Railtie.insert


##
# Geo_location model.
#
class Location < ActiveRecord::Base

  def initialize(ip_address, country, country_code, city, latitude, longitude)
    super()
    write_attribute :ip_address, ip_address
    write_attribute :country, country
    write_attribute :country_code, country_code
    write_attribute :city, city
    write_attribute :latitude, latitude
    write_attribute :longitude, longitude
  end
end

class GeocoderTestCase < Test::Unit::TestCase

  def setup
    super
    Geocoder::Configuration.instance.set_defaults
    Geocoder.configure(
      :maxmind => {:service => :city_isp_org},
      :maxmind_geoip2 => {:service => :insights, :basic_auth => {:user => "user", :password => "password"}})
  end

  def geocoded_object_params(abbrev)
    {
      :msg => ["Madison Square Garden", "4 Penn Plaza, New York, NY"]
    }[abbrev]
  end

  def reverse_geocoded_object_params(abbrev)
    {
      :msg => ["Madison Square Garden", 40.750354, -73.993371]
    }[abbrev]
  end

  def set_api_key!(lookup_name)
    lookup = Geocoder::Lookup.get(lookup_name)
    if lookup.required_api_key_parts.size == 1
      key = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    elsif lookup.required_api_key_parts.size > 1
      key = lookup.required_api_key_parts
    else
      key = nil
    end
    Geocoder.configure(:api_key => key)
  end
end