is_ci = ENV.fetch('IS_CI', false)

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :feature) do
      Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome_headless
      Capybara.current_driver = :selenium_chrome_headless
    end
  end
end

# Required to remove deprecation warnings coming from capybara. See: https://github.com/teamcapybara/capybara/issues/2779
Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)