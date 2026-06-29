require 'rails_helper'

describe 'Theme toggle', type: :feature, js: true do
  before(:each) do
    login_as(auth_users(:admin), scope: :auth_user)
    visit people_path
  end

  # The toggle <li> carries the Stimulus theme controller.
  def toggle
    find("[data-controller='theme']")
  end

  def html_theme
    page.find('html')['data-bs-theme']
  end

  it 'renders the toggle with an icon' do
    # The glyph is a span whose CSS mask points at one of the theme SVG assets
    # (app/assets/images/theme/*.svg); the controller sets the mask-image inline.
    icon = toggle.find('.theme-toggle-icon')
    expect(icon[:style]).to match(/mask-image:\s*url/)
  end

  it 'applies a resolved colour mode on load' do
    # "auto" resolves to light or dark depending on the OS; both are valid.
    expect(html_theme).to be_in(%w[light dark])
  end

  it 'cycles through the explicit light and dark modes without a reload' do
    # PREFS cycle: auto -> light -> dark. The explicit light/dark steps are
    # deterministic regardless of the OS preference.
    toggle.click
    expect(page).to have_css("html[data-bs-theme='light']")

    toggle.click
    expect(page).to have_css("html[data-bs-theme='dark']")
  end

  it 'persists the preference in the theme cookie' do
    toggle.click
    toggle.click
    expect(page.driver.browser.manage.all_cookies.find { |c| c[:name] == 'theme' }[:value])
      .to eq('dark')
  end
end
