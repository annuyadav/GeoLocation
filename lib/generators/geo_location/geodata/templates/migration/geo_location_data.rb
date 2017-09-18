class GeoLocationData < ActiveRecord::Migration<%= migration_version %>
  def self.up
    create_table :locations do |t|
      t.column :ip_address, :string, null: false
      t.column :country_code, :string
      t.column :country, :string, null: false
      t.column :city, :string, null: false
      t.column :latitude, :decimal, precision: 10, scale: 6, null: false
      t.column :longitude, :decimal, precision: 10, scale: 6, null: false
      t.column :mystery_value, :integer, limit: 8

    end
    add_index :locations, :ip_address, unique: true
    add_index :locations, [:latitude, :longitude], unique: true, name: 'locations_on_latitude_and_longitude'
  end

  def self.down
    drop_table :locations
  end
end