require_relative 'boot'

=begin new
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'
=end

# old
require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'active_storage/engine'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Puzzlecv2
  class Application < Rails::Application
    # Initialize configuration defaults for oiginally generated Rails version (new in 5.2.1)
    config.load_defaults 5.0

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

    # Schedule all cron jobs
    config.to_prepare do
      if Delayed::Job.table_exists?
        pattern = Rails.root.join('app', 'jobs', '**', '*_job.rb')
        Dir.glob(pattern).each { |file| require file }
        CronJob.subclasses.each { |job| job.schedule }
      end
    end
  end
end
