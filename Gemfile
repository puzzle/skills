# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '5.2.2.1'

gem 'active_model_serializers'
gem 'activerecord-postgresql-adapter'
gem 'airbrake', '~> 5.0'
gem 'annotate'
gem 'bleib', '0.0.8' # For deployment
gem 'bootsnap'
gem 'carrierwave'
gem 'config'
gem 'countries'
gem 'database_cleaner'
gem 'i18n_data'
gem 'language_list'
gem 'mini_magick'
gem 'net-ldap', '~> 0.16.0'
gem 'nokogiri', '~> 1.8.2'
gem 'odf-report'
gem 'pg'
gem 'pg_search'
gem 'puma'
gem 'rack'
gem 'rails-i18n'
gem 'seed-fu'

group :metrics do
  gem 'brakeman'
  gem 'rubocop', '~> 0.54.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code
  # to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'faker'
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'bullet'
  gem 'pry'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov'
  gem 'simplecov-rcov'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
