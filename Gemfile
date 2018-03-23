source 'https://rubygems.org'

gem 'rails', '5.1.5'

gem 'active_model_serializers', '~> 0.10.6'
gem 'activerecord-postgresql-adapter'
gem 'airbrake', '~> 5.0'
gem 'annotate'
gem 'carrierwave'
gem 'database_cleaner'
gem 'deep_cloneable', '~> 2.2.2'
gem 'faker'
gem 'mini_magick'
gem 'mysql2'
gem 'net-ldap', '~> 0.14.0'
gem 'odf-report'
gem 'pg', '0.19.0.pre20160409114042'
gem 'pg_search'
gem 'puma', '~> 3.0'
gem 'rack'
gem 'rails-i18n', '~> 5.0.4'
gem 'seed-fu', '~> 2.3.7'
gem 'sqlite3'

group :metrics do
  gem 'brakeman'
  gem 'rubocop'
end

group :development, :test do
  # Call 'byebug' anywhere in the code
  # to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'hirb'
  gem 'rspec-rails', '~> 3.6'
end

group :development do
  gem 'bullet'
  gem 'listen', '~> 3.0.5'
  gem 'pry'
  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', '~> 0.12.0'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
