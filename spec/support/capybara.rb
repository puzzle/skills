is_ci = ENV.fetch('IS_CI', false)

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[--headless --disable-gpu] },
      'goog:loggingPrefs': {
          browser: 'ALL'
      }
    )

  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities,
      options: options
    )
end

Capybara.default_driver = :headless_chrome

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :feature) do
      driven_by :headless_chrome
    end
  end
end
