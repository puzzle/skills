require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_storage/engine'
require 'action_mailer/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skills
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths += %W( #{config.root}/app/uploaders) #
    config.i18n.default_locale = :de

    config.active_job.queue_adapter = :delayed_job
    config.filter_parameters += [:authorizationToken]

    KEYCLOAK_ENV_VARS = %w[
      RAILS_KEYCLOAK_SERVER_URL
      RAILS_KEYCLOAK_REALM_ID
      EMBER_KEYCLOAK_SERVER_URL
      EMBER_KEYCLOAK_REALM_NAME
      EMBER_KEYCLOAK_CLIENT_ID
      EMBER_KEYCLOAK_SECRET
    ].freeze

    def keycloak_disabled?
      KEYCLOAK_ENV_VARS.none? { |e| ENV[e].present? } &&
        ENV['KEYCLOAK_DISABLED'].present?
    end

    unless Rails.env.test?
      # Schedule all cron jobs
      config.to_prepare do
        pattern = Rails.root.join('app', 'jobs', '**', '*_job.rb')
        Dir.glob(pattern).each { |file| require file }
        CronJob.subclasses.each { |job| job.schedule }
      end
    end
  end
end
