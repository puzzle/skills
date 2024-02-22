is_ci = ENV.fetch('IS_CI', false)

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_option('--headless')
  options.add_option('--no-sandbox')
  options.add_option('--disable-gpu')
  options.add_option('--disable-dev-shm-usage')


  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :feature) do
      driven_by :headless_chrome
    end
  end
end
