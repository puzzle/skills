source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'activerecord-postgresql-adapter'
gem 'active_model_serializers', '~> 0.10.0'
gem 'annotate'
gem 'devise'
gem 'devise_token_auth'
gem 'faker'
gem 'mysql2'
gem 'net-ldap', '~> 0.14.0'
gem 'omniauth'
gem 'omniauth-ldap'
gem 'pg', '0.19.0.pre20160409114042'
gem 'puma', '~> 3.0'
gem 'rack'
gem 'rails-i18n'
gem 'seed-fu'
gem 'sqlite3'
gem 'deep_cloneable', '~> 2.2.2'

group :metrics do
  gem 'brakeman'
  gem 'rubocop'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
end

group :development do
  gem 'bullet'
  gem 'listen', '~> 3.0.5'
  gem 'pry'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', '~> 0.12.0'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
