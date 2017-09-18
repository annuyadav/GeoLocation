require 'test_helper'
class LocationTest < ActiveSupport::TestCase

  def test_create_location_without_ip
    l = Location.new
    l.latitude, l.longitude = [40.750354, -73.993371]
    l.country, l.city = ['india', 'delhi']
    assert !location.save, 'Can not save the location without a ip_address'
  end

  def test_create_location_without_country
    l = Location.new
    l.latitude, l.longitude = [40.750354, -73.993371]
    l.ip_address, l.city = ['1.1.1.1', 'delhi']
    assert !location.save, 'Can not save the location without country'
  end

  def test_create_location_without_city
    l = Location.new
    l.latitude, l.longitude = [40.750354, -73.993371]
    l.country, l.ip_sddress = ['india', '1.1.1.1']
    assert !location.save, 'Can not save the location without a ip_address'
  end

  def test_create_location_without_latitude_and_longitude
    l = Location.new
    l.country = 'india'
    l.ip_address, l.city = ['1.1.1.1', 'delhi']
    assert !location.save, 'Can not save the location without latitude_and_longitude'
  end

  def test_create_location
    l = Location.new
    l.country = 'india'
    l.latitude, l.longitude = [40.750354, -73.993371]
    l.ip_address, l.city = ['1.1.1.1', 'delhi']
    assert location.save, 'Saved location'
  end
end