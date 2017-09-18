module GeoLocation
  class Query
    attr_accessor :text

    def initialize(text)
      self.text = text
    end

    def execute
      return [] if blank?
      if ip_address?
        return [] if loopback_ip_address?
        GeoLocation::Location.where(ip_address: text)
      elsif coordinates?
        GeoLocation::Location.where(latitude: coordinates.first, longitude: coordinates.last)
      elsif params?
        GeoLocation::Location.where(params_attributes)
      elsif search_value.is_a?(Array)
        GeoLocation::Location.where('city IN (?) OR country IN (?) OR country_code IN (?)', search_value, search_value, search_value)
      else
        GeoLocation::Location.where('city LIKE ? OR country LIKE ? OR country_code LIKE ?', "%#{search_value}%", "%#{search_value}%", "%#{search_value}%")
      end
    end

    def sanitized_text
      if text.is_a?(Array)
        text.join(',')
      else
        text.split(/\s*,\s*/).join(',')
      end
    end

    def search_value
      _values = sanitized_text.split(',')
      _values.size > 1 ? _values : sanitized_text
    end

    def params?
      text.is_a?(Hash)
    end

    def params_attributes
      h = {}
      if params?
        _location_attributes = GeoLocation::Location.attribute_names
        text.each do |k,v|
          h[k] = v.split(',').collect(&:strip) if _location_attributes.include(k.to_s)
        end
      end
      h
    end

    ##
    # Is the Query blank?
    def blank?
      (text.is_a?(Array) and text.compact.size < 2) or
          text.to_s.match(/\A\s*\z/)
    end

    ##
    # Does the Query text look like an IP address?
    def ip_address?
      IpAddress.new(text).valid? rescue false
    end

    ##
    # Is the Query text a loopback IP address?
    def loopback_ip_address?
      ip_address? && IpAddress.new(text).loopback?
    end

    ##
    # Does the given string look like latitude/longitude coordinates?
    def coordinates?
      text.is_a?(Array) or (
      text.is_a?(String) and
          !!text.to_s.match(/\A-?[0-9\.]+, *-?[0-9\.]+\z/)
      )
    end

    ##
    # Return the latitude/longitude coordinates specified in the query,
    # or nil if none.
    def coordinates
      sanitized_text.split(',') if coordinates?
    end
  end
end
