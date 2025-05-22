require 'rails_helper'

describe :skills do
  before(:each) do
    admin = auth_users(:admin)
    login_as(admin, scope: :auth_user)
  end

  def fill_out_form
    fill_in 'skill_title', with: 'new Title'
    select 'System-Engineering', from: 'skill_category_parent'
    select 'Linux-Engineering', from: 'skill_category_id'

    check 'skill_default_set'
    select 'adopt', from: 'skill_radar'
    select 'nein', from: 'skill_portfolio'
  end

  describe 'Edit skill', type: :feature, js: true do
    it 'can edit skill in table ' do
      visit skills_path
      within "#skill_#{Skill.second.id}" do
        page.find('.icon.icon-pencil').click
        expect(page).to have_field('skill_title', with: Skill.second.title)
        expect(page).to have_select('skill_category_parent', selected: Skill.second.category.parent.title)
        expect(page).to have_select('skill_category_id', selected: Skill.second.category.title)
        expect(page).to have_field('skill_default_set', checked: false)
        expect(page).to have_select('skill_radar', options: Settings.radar, selected: Skill.second.radar)
        expect(page).to have_select('skill_portfolio', options: Settings.portfolio, selected: Skill.second.portfolio)
      end
    end

    it 'can save edited skill' do
      visit skills_path
      page.all('.icon.icon-pencil')[1].click
      fill_out_form
      save_button = page.find("input[type='image']")
      save_button.click
      expect(page).to have_css("div.row.border.border-top.table-light.tableform-hover.table-row", text: 'new Title', wait: 2)

      edited_skill = Skill.where(title: 'new Title')[0]
      expect(edited_skill.category.title).to eq('Linux-Engineering')
      expect(edited_skill.category.parent.title).to eq('System-Engineering')
      expect(edited_skill.default_set).to eq(true)
      expect(edited_skill.radar).to eq('adopt')
      expect(edited_skill.portfolio).to eq('nein')
    end

    it 'can cancel edited skill' do
      visit skills_path
      page.all('.icon.icon-pencil')[1].click

      fill_out_form
      save_button = page.first("img.pointer")
      save_button.click

      skill = Skill.first
      expect(skill.title).to eq('Rails')
      expect(skill.category.title).to eq('Ruby')
      expect(skill.category.parent.title).to eq('Software-Engineering')
      expect(skill.default_set).to eq(true)
      expect(skill.radar).to eq('adopt')
      expect(skill.portfolio).to eq('aktiv')
    end
    it 'button is disabled when you are no admin' do
      sign_in auth_users(:user), scope: :auth_user
      visit skills_path
      within "#skill_#{Skill.second.id}" do
        page.find('.icon.icon-pencil').disabled?
      end
    end
  end

  describe 'Export skill', type: :feature do
    it 'button is disabled when you are no admin' do
      sign_in auth_users(:user), scope: :auth_user
      visit skills_path
      page.find('.icon.icon-export').disabled?
    end
  end

  describe 'sort skillsets' do
    it 'should be able to sort skillset table' do
      visit skills_path
      Skill.attribute_names.excluding("id", "created_at", "updated_at", "category_id", "discarded_at").including("category", "members", "subcategory").each do |attr|
        click_link Skill.human_attribute_name(attr)
        expect(page).to have_current_path(skills_path(sort: attr, sort_dir: 'asc'))
        click_link Skill.human_attribute_name(attr)
        expect(page).to have_current_path(skills_path(sort: attr, sort_dir: 'desc'))
      end
    end
  end
end
