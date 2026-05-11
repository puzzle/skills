is_ci = ENV.fetch('IS_CI', false)
headless = ENV.fetch('HEADLESS', false)

if headless
  Capybara.register_driver :firefox_headless do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('-headless')
    options.add_argument('--width=1920')
    options.add_argument('--height=1080')

    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      options: options
    )
  end
  Capybara.javascript_driver = :firefox_headless
end

if is_ci
  RSpec.configure do |config|
    config.before(:each, type: :feature) do
      Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome_headless
      Capybara.current_driver = :selenium_chrome_headless
    end
  end
end

# ToDo: Remove when capybara is updated. Required to remove deprecation warnings coming from capybara. See: https://github.com/teamcapybara/capybara/issues/2779
Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)