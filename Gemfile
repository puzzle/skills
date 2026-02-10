# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 8.1.2'

gem 'abbrev'
gem 'active_model_serializers'
gem 'activerecord-postgresql-adapter'
gem 'annotate'
gem 'bigdecimal'
gem 'bleib' # For deployment
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
gem 'discard'
gem 'drb'
gem 'faker'
gem 'haml-rails'
gem 'i18n_data'
gem 'jsbundling-rails'
gem 'language_list'
gem 'mini_magick'
gem 'mutex_m'
gem 'net-imap', require: false
gem 'net-ldap'
gem 'net-pop', require: false
gem 'net-smtp', require: false
gem 'nokogiri'
gem 'odf-report'
gem 'omniauth-keycloak'
gem 'omniauth-rails_csrf_protection'
gem 'pg'
gem 'pg_search'
gem 'psych'
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
  gem 'i18n-tasks'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'bullet'
  gem 'dotenv'
  gem 'listen'
  gem 'overcommit'
  gem 'rb-readline'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '>= 4.28.0'
  gem 'simplecov'
  gem 'webmock'
  # Use fixed version of webdrivers to avoid compatibility issues with chrome and chromedriver
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'rails-controller-testing'
