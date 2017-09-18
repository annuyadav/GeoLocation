# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_location/version'

Gem::Specification.new do |spec|
  spec.name          = 'geo_location'
  spec.version       = GeoLocation::VERSION
  spec.authors       = ['Annu Yadav']
  spec.email         = ['life.annu.yadav@gmail.com']

  spec.summary       = %q{Gem for geo location}
  spec.description   = %q{This gem is used to export CSV data and then make it available to end user via model.}
  spec.homepage      = 'https://github.com/annuyadav/GeoLocation'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/annuyadav/GeoLocation'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rails'
end
