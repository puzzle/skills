Airbrake.configure do |config|
  config.host = 'https://errbit.puzzle.ch'
  config.project_id = '42' # needs to be set to anything when using with errbit
  config.project_key = ENV['ERRBIT_PROJECT_KEY']

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
