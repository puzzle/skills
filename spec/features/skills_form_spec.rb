require 'rails_helper'


describe 'Skill Form', type: :feature, js:true do
  before do
    visit skills_path
    click_link(href: new_skill_path)
    @category = categories(:ruby)
    @radar = "hold"
    @portfolio = "passiv"
  end

  it 'creates the skill when the form is submitted' do
    fill_in 'skill_title', with: 'New Skill Title'
    select @category.title, from: 'skill_category_id'
    select @radar, from: 'skill_radar'
    select @portfolio, from: 'skill_portfolio'
    click_button 'Skill erstellen'
    all 'tbody tr', count: 6
    # Check for the skill names instead of the amount
    within('tbody') do
      expect(page).to have_content('Bash')
      expect(page).to have_content('cunit')
      expect(page).to have_content('ember')
      expect(page).to have_content('JUnit')
      expect(page).to have_content('Rails')
      expect(page).to have_content('New Skill Title')
    end
  end

  it 'displays error messages when present' do
    fill_in 'skill_title', with: ''
    click_button 'Skill erstellen'

    expect(page).to have_css('.alert.alert-danger')
  end

  it 'redirects to the skills index when the cancel button is clicked' do
    click_link(href:skills_path, text: "Cancel")
    all 'tbody tr', count: 5
  end
end
