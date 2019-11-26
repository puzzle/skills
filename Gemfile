# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '6.0.1'

gem 'active_model_serializers'
gem 'activerecord-postgresql-adapter'
gem 'annotate'
gem 'bleib', '0.0.8' # For deployment
gem 'bootsnap'
gem 'carrierwave'
gem 'config'
gem 'countries'
gem 'database_cleaner'
gem 'i18n_data'
gem 'keycloak-api-rails'
gem 'language_list'
gem 'mini_magick'
gem 'net-ldap', '~> 0.16.0'
gem 'nokogiri', '~> 1.10.4'
gem 'odf-report'
gem 'pg'
gem 'pg_search'
gem 'puma'
gem 'rack'
gem 'rails-i18n'
gem 'rest-client'
gem 'seed-fu'
gem 'sentry-raven'

group :metrics do
  gem 'brakeman'
  gem 'rubocop', '~> 0.54.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code
  # to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails', '~> 3.6'
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


{
  "realm": "pitc",
  "auth-server-url": "https://sso-test.puzzle.ch/auth/",
  "ssl-required": "external",
  "resource": "pitc-skills-backend",
  "verify-token-audience": true,
  "credentials": {
    "secret": "a60e5d3b-ae33-4e7a-8dd3-8d6ce5734b61"
  },
  "use-resource-role-mappings": true,
  "confidential-port": 0
}
