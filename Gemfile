# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 8.0'

gem 'abbrev'
gem 'active_model_serializers'
gem 'activerecord-postgresql-adapter'
gem 'annotate'
gem 'bigdecimal'
gem 'bleib', '0.0.8' # For deployment
gem 'bootsnap'
gem 'bundler-audit'
gem 'carrierwave'
gem 'config'
gem 'countries'
gem 'cssbundling-rails'
gem 'csv'
gem 'database_cleaner'
gem 'delayed_cron_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'discard', '~> 1.4'
gem 'drb'
gem 'faker'
gem 'haml-rails'
gem 'i18n_data'
gem 'jsbundling-rails'
gem 'language_list'
gem 'mini_magick'
gem 'mutex_m'
gem 'net-imap', require: false
gem 'net-ldap', '~> 0.16.0'
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'nokogiri'
gem 'odf-report'
gem 'omniauth-keycloak'
gem 'omniauth-rails_csrf_protection'
gem 'overcommit'
gem 'pg'
gem 'pg_search'
gem 'psych', '~> 3.3', '>= 3.3.4'
gem 'puma'
gem 'rack'
gem 'rails-i18n'
gem 'rest-client'
gem 'seed-fu'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

group :metrics do
  gem 'brakeman'
  gem 'haml_lint', require: false
  gem 'rubocop'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code
  # to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'i18n-tasks', '~> 1.0.14'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'bullet'
  gem 'debugbar'
  gem 'dotenv'
  gem 'listen'
  gem 'rb-readline'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '>= 4.28.0'
  gem 'simplecov'
  gem 'webmock'
  # Use fixed version of webdrivers to avoid compatibility issues with chrome and chromedriver
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rails-controller-testing', '~> 1.0'
