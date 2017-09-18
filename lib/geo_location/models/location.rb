# require 'will_paginate'

module GeoLocation
    class Location < ActiveRecord::Base
      #---Validations ------------------------------------------------
      validates :country, :city, :latitude, :longitude, presence: true
      validates :latitude, :uniqueness => {:scope => :longitude}
      validates :ip_address, :presence => true, :uniqueness => true,
                :format => { :with => Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)}

      #---Class Methods ----------------------------------------------
      # def self.search(query)
      #   query = GeoLocation::Query.new(query) unless query.is_a?(GeoLocation::Query)
      #   query.execute
      # end
    end
end
