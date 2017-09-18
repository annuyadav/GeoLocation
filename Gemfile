source 'https://rubygems.org'

group :development, :test do
  gem 'rake'
  gem 'rails'
  gem 'test-unit' # needed for Ruby >=2.2.0

  gem 'byebug', platforms: :mri
end

group :test do
  platforms :ruby do
    gem 'sqlite3'
    gem 'sqlite_ext', '~> 1.5.0'
    gem 'pg'
    gem 'mysql2', '~> 0.3.11'
  end
end

gemspec
