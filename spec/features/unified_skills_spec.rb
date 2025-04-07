require 'rails_helper'

describe 'Unified Skills', type: :feature, js: true do
  before(:each) do
    sign_in auth_users(:admin)
    visit new_admin_unified_skill_path
  end

  let(:new_skill) { Skill.new(title: 'A unified skill', radar: 'hold', portfolio: 'nein', category_id: Category.first.id, default_set: true) }

  it 'should unify two skills' do
    skill1 = skills(:rails)
    skill2 = skills(:bash)

    select_from_slim_select('#unified_skill_form_old_skill_id1', skill1.title)
    select_from_slim_select('#unified_skill_form_old_skill_id2', skill2.title)

    fill_in 'unified_skill_form_new_skill_title', with: new_skill.title
    select new_skill.category.title, from: 'unified_skill_form_new_skill_category_id'
    select new_skill.radar, from: 'unified_skill_form_new_skill_radar'
    select new_skill.portfolio, from: 'unified_skill_form_new_skill_portfolio'
    check 'unified_skill_form_new_skill_default_set'

    click_button 'Auf Konflikte prüfen'

    expect(page).to have_content('Alice Mante und Wally Allround haben beide Skills bewertet. Werden die Skills trotzdem vereint, wird die bessere Bewertung genommen.')

    click_button 'Vereinen'

    expect(page).to have_content("Skill #{skill1.title} wurde erfolgreich mit Skill #{skill2.title} vereint")
    expect(Skill.find_by(id: skill1.id)).to be_nil
    expect(Skill.find_by(id: skill2.id)).to be_nil

    unified_skill = Skill.find_by!(title: 'A unified skill')
    expect(unified_skill.radar).to eql(new_skill.radar)
    expect(unified_skill.portfolio).to eql(new_skill.portfolio)
    expect(unified_skill.category_id).to eql(new_skill.category_id)
    expect(unified_skill.default_set).to eql(new_skill.default_set)
  end

  it 'should show validation errors' do
    unified_skill_form = UnifiedSkillForm.new(new_skill: new_skill.attributes.without(:title))
    unified_skill_form.valid?

    click_button 'Auf Konflikte prüfen'
    unified_skill_form.errors.full_messages.each do |error_message|
      expect(page).to have_content(error_message)
    end


    skill = Skill.first
    unified_skill_form.old_skill_id1 = skill.id
    unified_skill_form.old_skill_id2 = skill.id
    unified_skill_form.valid?

    select_from_slim_select('#unified_skill_form_old_skill_id1', skill.title)
    select_from_slim_select('#unified_skill_form_old_skill_id2', skill.title)

    click_button 'Auf Konflikte prüfen'

    unified_skill_form.errors.full_messages.each do |error_message|
      expect(page).to have_content(error_message)
    end
  end

  it 'should correctly display conflicts' do
    # Check initial state
    expect(page).not_to have_button('Vereinen')
    expect(page).to have_button('Auf Konflikte prüfen')

    # Select two skills and check for conflicts
    select_from_slim_select('#unified_skill_form_old_skill_id1', 'Rails')
    select_from_slim_select('#unified_skill_form_old_skill_id2', 'Bash')
    click_button('Auf Konflikte prüfen')

    # It should exclusively show validation failures until the model is valid
    expect(page).to have_content('Skill title muss ausgefüllt werden')
    expect(page).not_to have_button('Vereinen')
    expect(page).to have_button('Auf Konflikte prüfen')

    # Fill in title to make model valid
    fill_in 'unified_skill_form_new_skill_title', with: 'Neuer Titel'
    click_button('Auf Konflikte prüfen')

    # It should now show the new unify button and the notice
    expect(page).to have_button('Vereinen')
    expect(page).not_to have_button('Auf Konflikte prüfen')
    expect(page).to have_content('Alice Mante und Wally Allround haben beide Skills bewertet. Werden die Skills trotzdem vereint, wird die bessere Bewertung genommen.')

    # Select another Skill that will produce no conflicts
    select_from_slim_select('#unified_skill_form_old_skill_id1', 'WebComponents')

    # Check that changing the Skill has reset the button and check for conflicts again
    expect(page).not_to have_button('Vereinen')
    expect(page).to have_button('Auf Konflikte prüfen')
    click_button('Auf Konflikte prüfen')

    # Check that the user is notified, that no conflicts have been found and that the button state is correct
    expect(page).to have_content('Es wurden keine Konflikte gefunden. Die Skills können problemlos vereint werden.')
    expect(page).to have_button('Vereinen')
    expect(page).not_to have_button('Auf Konflikte prüfen')
  end
end