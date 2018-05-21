Airbrake.configure do |config|
  config.host = ENV['RAILS_AIRBRAKE_HOST']
  config.project_id = '42' # needs to be set to anything when using with errbit
  config.project_key = ENV['RAILS_AIRBRAKE_API_KEY']

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
