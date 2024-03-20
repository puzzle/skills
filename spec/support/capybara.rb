is_ci = ENV.fetch('IS_CI', false)

RSpec.configure do |config|
  if is_ci
    config.before(:each, type: :feature) do
      Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome_headless
      Capybara.current_driver = :selenium_chrome_headless
    end
  end
end
