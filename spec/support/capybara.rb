is_ci = ENV.fetch('IS_CI', false)

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  Webdrivers::Chromedriver.required_version = '114.0.5735.90'


  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :feature) do
      Capybara.current_driver = :headless_chrome
    end
  end
end
