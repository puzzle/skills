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
    require "pry"; binding.pry
    click_button 'Close'
    expect(@skill.reload.title).to eq('New Skill Title')
    expect(page).to have_current_path(skills_path)
  end

  it 'displays error messages when present' do
    visit edit_skill_path(@skill) # replace with the actual path to your form

    fill_in 'Title', with: ''
    click_button 'Close'

    expect(page).to have_css('.alert.alert-danger')
  end

  it 'redirects to the skills index when the cancel button is clicked' do
    visit edit_skill_path(@skill)

    click_link 'Cancel'

    expect(page).to have_current_path(skills_path)
  end
end
