require 'rails_helper'


describe 'Skill Form', type: :system, js:true do
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
  end

  it 'displays error messages when present' do
    fill_in 'skill_title', with: ''
    click_button 'Skill erstellen'

    expect(page).to have_css('.alert.alert-danger')
  end

  it 'redirects to the skills index when the cancel button is clicked' do
    click_link(href:skills_path)
    all 'tbody tr', count: 5
  end
end
