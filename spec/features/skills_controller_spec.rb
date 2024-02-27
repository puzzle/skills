require 'rails_helper'

describe :skills do
  def fill_out_form
    fill_in 'skill_title', with: 'new Title'
    parent_select = first('#skill_category_id')
    parent_select.select "System-Engineering"

    child_select = page.all('#skill_category_id')[1]
    child_select.select "Linux-Engineering"

    check 'skill_default_set'
    select 'adopt', from: 'skill_radar'
    select 'nein', from: 'skill_portfolio'
  end

  describe 'Edit skill', type: :feature, js: true do
    it 'can edit skill in table ' do
      visit skills_path
      within "#skill_#{Skill.first.id}" do
        page.first('.edit-button').click
        expect(page).to have_field('skill_title', with: Skill.first.title)
        expect(page).to have_select('skill_category_id', selected: Skill.first.category.parent.title)
        expect(page).to have_select('skill_category_id', selected: Skill.first.category.title)
        expect(page).to have_field('skill_default_set', checked: true)
        expect(page).to have_select('skill_radar', options: Settings.radar, selected: Skill.first.radar)
        expect(page).to have_select('skill_portfolio', options: Settings.portfolio, selected: Skill.first.portfolio)
      end
    end

    it 'can save edited skill' do
      visit skills_path
      page.first('.edit-button').click
      within 'div[data-controller="table"]' do
        fill_out_form
        within 'div.h-100.d-flex.justify-content-center.align-items-center' do
          save_button = page.find("input[type='image']")
          save_button.click
        end
      end
      edited_skill = Skill.where(title: 'new Title')[0]
      expect(edited_skill.category.title).to eq('Linux-Engineering')
      expect(edited_skill.category.parent.title).to eq('System-Engineering')
      expect(edited_skill.default_set).to eq(true)
      expect(edited_skill.radar).to eq('adopt')
      expect(edited_skill.portfolio).to eq('nein')
    end

    it 'can cancel edited skill' do
      visit skills_path
      page.first('.edit-button').click

      within "#skill_#{Skill.first.id}" do
        page.first('.edit-button').click
        fill_out_form
        within 'div.h-100.d-flex.justify-content-center.align-items-center' do
          save_button = page.find("img.pointer")
          save_button.click
        end
      end

      skill = Skill.first
      expect(skill.title).to eq('Rails')
      expect(skill.category.title).to eq('Ruby')
      expect(skill.category.parent.title).to eq('Software-Engineering')
      expect(skill.default_set).to eq(true)
      expect(skill.radar).to eq('adopt')
      expect(skill.portfolio).to eq('aktiv')
    end
  end
end
