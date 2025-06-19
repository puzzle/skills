require "active_record"
require "bullet"

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/capybara'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.example_status_persistence_file_path = "tmp/failures.txt"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before :all do
    # load all fixtures
    self.class.fixtures :all
  end

  config.before(:each, js: true) do
    Capybara.page.current_window.resize_to(1920, 1080)
  end

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end

  config.infer_spec_type_from_file_location!

  config.before(:each) do
    stub_env_var("USE_PTIME_SYNC", false)
    PeopleController.permitted_attrs = PeopleController.instance_variable_get("@default_permitted_attrs")
  end

  show_logs = ENV.fetch('SHOW_LOGS', false)
  config.before { allow($stdout).to receive(:puts) } unless show_logs

  # Controller helper
  config.include(JsonMacros, type: :controller)
  config.include(JsonAssertion, type: :controller)
  config.include(ControllerHelpers, type: :controller)
  config.include DefaultParams, type: :controller


  # Feature helper

  # Helpers from gems
  config.include(Devise::Test::IntegrationHelpers, type: :feature)
  config.include(Devise::Test::IntegrationHelpers, type: :request)
  config.include(Devise::Test::ControllerHelpers, type: :controller)
  config.include(ActionView::RecordIdentifier, type: :feature)

  # Custom helpers
  config.include(PersonRelationsHelpers, type: :feature)
  config.include(SlimselectHelpers, type: :feature)
  config.include(PeopleSkillsHelpers, type: :feature)
  config.include(UtilitiesHelpers)
  config.include(PtimeHelpers)
  config.include(JsonHelpers)

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.after(:each) do
    I18n.locale = I18n.default_locale
  end

  config.before(:each, type: :feature) do
    default_url_options[:locale] = I18n.locale
  end
end
