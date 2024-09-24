require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_storage/engine'
require 'action_mailer/railtie'
require("bootstrap");

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skills
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.autoload_paths += %W( #{config.root}/app/uploaders) #
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.available_locales = [:de, :en, :fr, :it]
    config.i18n.default_locale = :de

    config.active_record.verify_foreign_keys_for_fixtures = false

    # Bullet tries to add finish_at to insert statement, which does not exist anymore
    config.active_record.partial_inserts = true

    config.filter_parameters += [:authorizationToken]

    config.assets.enabled = true
    config.assets.paths << Rails.root.join("uploads")
  end
end
