# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '7.0.4.2'

gem 'active_model_serializers'
gem 'activerecord-postgresql-adapter'
gem 'annotate'
gem 'bleib', '0.0.8' # For deployment
gem 'bootsnap'
gem 'carrierwave'
gem 'config'
gem 'countries'
gem 'database_cleaner'
gem 'faker'
gem 'i18n_data'
gem 'keycloak-api-rails'
gem 'language_list'
gem 'mimemagic', '~> 0.3.6'
gem 'mini_magick'
gem 'net-imap', require: false
gem 'net-ldap', '~> 0.16.0'
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'nokogiri', '~> 1.14'
gem 'odf-report'
gem 'pg'
gem 'pg_search'
gem 'psych', '~> 3.3', '>= 3.3.4'
gem 'puma'
gem 'rack'
gem 'rails-i18n'
gem 'rest-client'
gem 'seed-fu'
gem 'sentry-raven'

group :metrics do
  gem 'brakeman'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code
  # to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 4.0.2'
end

group :development do
  gem 'bullet'
  gem 'listen', '~> 3.0.5'
  gem 'rb-readline'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
