require 'rails_helper'

describe 'Profile scroll-to', type: :feature, js: true do
  let(:longmax) { people(:longmax) }

  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
    visit root_path
    Capybara.page.driver.browser.manage.window.maximize
  end

  it 'Should change background of selected section' do
    visit person_path(longmax)
    page.find('span', text: 'Ausbildung').click
    expect(page.all('div', text: 'Ausbildung')[0]).to have_css('.skills-selected')

    sleep(1)
    page.find('span', text: 'Projekte').click
    expect(page.all('div', text: 'Projekte')[0]).to have_css('.skills-selected')
  end

  it 'Should be in viewport when clicked on list item' do
    visit person_path(longmax)
    page.find('span', text: 'Weiterbildung').click

    in_view = evaluate_script("(function(el) {
      var rect = el.getBoundingClientRect();
      return (
        rect.top >= 0 && rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      )
    })(arguments[0]);", page.find('span', text: 'Weiterbildung'))
    expect(in_view).to be true
  end
end