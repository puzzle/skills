require_relative "boot"

require "rails"

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_storage/engine'
require 'action_mailer/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skills
  def self.use_ptime_sync?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch('USE_PTIME_SYNC', false))
  end
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    I18n.available_locales = [:de, :en, :fr, :it, :ja, "de-CH"]
    config.i18n.default_locale = :de

    config.active_record.verify_foreign_keys_for_fixtures = false

    config.active_job.queue_adapter = :delayed_job

    # Bullet tries to add finish_at to insert statement, which does not exist anymore
    config.active_record.partial_inserts = true

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks templates custom_cops])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
