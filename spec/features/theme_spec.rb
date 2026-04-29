require 'rails_helper'

describe "Theme", type: :feature, js: true do
  let(:cookie) { Capybara.current_session.driver.browser.manage.cookie_named('theme')[:value] }

  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit people_path
  end

  describe "Dark Theme" do
    it "should apply the Theme and save it in the cookie" do
      select_from_slim_select("#theme", "Dunkel")

      page.should have_css("html.theme-dark")
      expect(cookie).to eq("dark")
    end
  end

  describe "Light Theme" do
    it "should apply the Theme and save it in the cookie" do
      select_from_slim_select("#theme", "Hell")

      page.should_not have_css("html.theme-dark")
      expect(cookie).to eq("light")
    end
  end
end