require 'csv'
require 'active_record'
require 'geo_location/models/location'

module GeoLocation
  module GeodataDatabase
    extend self

    def insert(file)
      file_path, model = file_path_and_table(file)
      insert_into_table(model, file_path)
    end

    private

    def table_columns(model)
      model.attribute_names
    end

    def insert_into_table(model, file_path)
      start_time = Time.now
      table = model.table_name
      print "Adding data to table #{table}..."
      print "Loading data for table #{table}"
      rows = []
      invalid_rows = []
      _headers = CSV.read(file_path, headers: true).headers
      columns = _headers & table_columns(model)
      CSV.foreach(file_path, {encoding: "ISO-8859-1", headers: true}) do |line|
        _line = line.values_at(*columns).compact
        _attrs = line.select { |k, v| columns.include?(k) }.to_h
        _location = model.new(_attrs)
        begin
          if _location.valid?
            rows << _line
            if rows.size == 100
              insert_rows(table, columns, rows.uniq)
              rows = []
              print '..'
            end
          else
            line[:errors] = _location.errors.full_messages.join(',')
            invalid_rows << line
          end
        rescue
        end
      end
      insert_rows(table, columns, rows) if rows.size > 0
      puts "data addition done (#{Time.now - start_time} seconds)"
      add_data_to_error_csv(invalid_rows)
    end

    def insert_rows(table, headers, rows)
      value_strings = rows.map do |row|
        '(' + row.map { |col| sql_escaped_value(col) }.join(',') + ")"
      end
      q = if ActiveRecord::Base.connection_config[:adapter] == 'postgresql'
            "INSERT INTO #{table} (#{headers.join(',')}) " +
                "VALUES #{value_strings.join(',')} ON CONFLICT DO NOTHING;"
          else
            "INSERT IGNORE INTO #{table} (#{headers.join(',')}) " +
                "VALUES #{value_strings.join(',')};"
          end
      ActiveRecord::Base.connection.execute(q)
    end

    def sql_escaped_value(value)
      value.to_i.to_s == value ? value :
          ActiveRecord::Base.connection.quote(value)
    end

    def file_path_and_table(file)
      [file.try(:path) || file, GeoLocation::Location]
    end

    def add_data_to_error_csv(csv_data)
      _error_file_name = Rails.root.join('tmp', "upload_error_#{Time.now.to_i}.csv")
      CSV.open(_error_file_name, "wb") do |csv|
        csv << csv_data.first.to_h.keys
        csv_data.each do |csv_data|
          csv << csv_data
        end
      end
      puts "All incorrect data are entered in  #{_error_file_name}"
    end
  end
end