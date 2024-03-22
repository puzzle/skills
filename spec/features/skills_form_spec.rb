require 'rails_helper'


describe 'Skill Form', type: :feature, js:true do

  before(:each) do
    sign_in auth_users(:admin), scope: :auth_user
    visit skills_path
    click_link(href: new_skill_path)
    @category = categories(:ruby)
    @radar = "hold"
    @portfolio = "passiv"
  end

  it 'creates the skill when the form is submitted' do
    fill_in 'skill_title', with: 'New Skill'
    select @category.title, from: 'skill_category_id'
    select @radar, from: 'skill_radar'
    select @portfolio, from: 'skill_portfolio'
    click_button 'Skill erstellen'
    # Check for the skill names instead of the amount
      expect(page).to have_content('Bash')
      expect(page).to have_content('cunit')
      expect(page).to have_content('ember')
      expect(page).to have_content('JUnit')
      expect(page).to have_content('Rails')
      expect(page).to have_content('New Skill')
  end

  it 'displays error messages when present' do
    fill_in 'skill_title', with: ''
    click_button 'Skill erstellen'

    expect(page).to have_css('.alert.alert-danger')
  end

  it 'redirects to the skills index when the cancel button is clicked' do
    click_link(href:skills_path, text: "Cancel")
    all 'turbo-frame[id^="skill"]', count: 5
  end
end
