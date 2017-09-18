module GeoLocation
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'tasks/geodata.rake'
      end
    end
  end
end
