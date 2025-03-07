require 'rails_helper'

describe "Skills Filter", type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
  end

  it 'should filter by category' do
    visit skills_path
    select "Software-Engineering", from: "category"
    expect(page).to have_content("System-Engineering").once
  end

  it 'should filter by default set' do
    visit skills_path
    page.all('label.btn')[2].click
    expect(page).to have_no_content(false)
  end

  it 'should filter by title' do
    visit skills_path
    fill_in 'title', with: 'Bash'
    expect(page).to have_no_content("JUnit")
    expect(page).to have_no_content("cunit")
    expect(page).to have_no_content("ember")
    expect(page).to have_content("Bash")
  end

  ["Web Components", "WebComponents", "web components", "webcomponents", " w e b co  mpo ne n   ts"].each do |query|
    it 'should filter by title space insensitive' do
      visit skills_path
      fill_in 'title', with: query
      expect(page).to have_no_content("JUnit")
      expect(page).to have_no_content("cunit")
      expect(page).to have_no_content("ember")
      expect(page).to have_content("Web Components")
      expect(page).to have_content("WebComponents")
    end
  end

  it 'should be able to combine filters' do
    visit skills_path
    fill_in 'title', with: 'unit'
    expect(page).to have_content("JUnit")
    expect(page).to have_content("cunit")

    page.all('label.btn')[2].click
    expect(page).to have_content("JUnit")
    expect(page).to have_no_content("cunit")

    find("#title").send_keys([:control, 'a'], :space)
    expect(page).to have_content("Rails")

    select "System-Engineering", from: "category"
    expect(page).to have_no_content("Rails")
  end
end
