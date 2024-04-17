is_ci = ENV.fetch('IS_CI', false)

RSpec.configure do |config|
  if true
    config.before(:each, type: :feature) do
      Capybara.default_driver = Capybara.javascript_driver = :selenium
      Capybara.current_driver = :selenium
    end
  end
end
