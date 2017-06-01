Airbrake.configure do |config|
  config.host = 'https://errbit.puzzle.ch'
  config.project_id = ENV['ERRBIT_PROJECT_ID']
  config.project_key = ENV['ERRBIT_PROJECT_KEY']

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
