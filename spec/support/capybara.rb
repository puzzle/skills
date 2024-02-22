is_ci = ENV.fetch('IS_CI', false)

Capybara.register_driver :headless do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('--headless')


  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options
  )
end

Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  if true
    config.before(:each, type: :feature) do
      Capybara.default_driver = Capybara.javascript_driver = :headless
      Capybara.current_driver = :headless
    end
  end
end
