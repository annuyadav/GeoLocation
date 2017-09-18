require 'geodata_database'

namespace :geo_location do
  namespace :geodata do
    namespace :geolite do

      desc 'insert geolocation data in database'
      task insert: [:environment] do
        _file = GeoDataTask.check_for_file!
        GeoDataTask.insert!(_file)
      end
    end
  end
end

module GeoDataTask
  extend self

  def check_for_file!
    file = ENV['file']
    if file.present?
      if File.exist?(file)
        _file = File.new(file)
        if _file.path.split('.').last.to_s.downcase != 'csv'
          puts 'Please upload only csv file'
          exit
        end
        return _file
      else
        puts 'Please provide the absolute path of file'
        exit
      end
    else
      puts 'Please specify the file with file=path/to/file'
      exit
    end
  end

  def insert!(file)
    GeoLocation::GeodataDatabase.insert(file)
  end
end
