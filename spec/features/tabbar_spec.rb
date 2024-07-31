require 'rails_helper'

describe 'Tabbar', type: :feature, js:true do
  let(:bob) { people(:bob) }

  let(:global_tabs){
    [
      { title: t('global.navbar.profile'), path: people_path },
      { title: t('global.navbar.skill_search'), path: people_skills_path },
      { title: t('global.navbar.cv_search'), path: cv_search_index_path },
      { title: t('global.navbar.skillset'), path: skills_path }
    ]
  }

  let(:person_tabs) {
    [
      { title: 'CV', path: person_path(bob) },
      { title: 'Skills', path: person_people_skills_path(bob) }
    ]
  }

  before(:each) do
    sign_in auth_users(:admin)
    visit root_path
  end

  describe 'Global' do
    it 'Should highlight right tab using click' do
      global_tabs.each do |hash|
        click_link(href: hash[:path])
        check_highlighted_tab(hash[:title])
      end
    end

    it 'Should highlight right tab after visit by url' do
      global_tabs.each do |hash|
        visit (hash[:path])
        check_highlighted_tab(hash[:title])
      end
    end


    def check_highlighted_tab(text)
      expect(page).to have_selector("div.skills-navbar .btn .nav-link.active", text: text)
    end
  end

  describe 'Person' do

    it 'Should highlight right tab using dropdown' do
      person_tabs.each do |hash|
        visit root_path
        select_from_slim_select("#person_id_person", bob.name)
        check_highlighted_tab("CV")
        click_link(href: hash[:path])
        check_highlighted_tab(hash[:title])
      end
    end

    it 'Should highlight right tab after visit by url' do
      person_tabs.each do |hash|
        visit (hash[:path])
        check_highlighted_tab(hash[:title])
      end
    end

    def check_highlighted_tab(text)
      expect(page).to have_selector(".nav.nav-tabs .btn .nav-link.active", text: text)
    end
  end
end
