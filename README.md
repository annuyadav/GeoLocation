# GeoLocation

This gem is used to export data of provided CSV file that contains raw geolocation data and provide an interface to access the geolocation data (model layer)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geo_location', :git => 'git@github.com:annuyadav/GeoLocation.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geo_location, :git => 'git@github.com:annuyadav/GeoLocation.git'

## Usage

Execute task to copy migrations from engine to rails application:

```ruby
rails generate geo_location:geodata:geo_location_data
```

Edit <tt>xxxxxxxxxxxxxx_geo_location_data.rb</tt> to add more fields and do up migrations:

```ruby
rake db:migrate
```

Upload CSV:

```ruby
rake geo_location:geodata:geolite:insert file='absolute/path/of/file'
```