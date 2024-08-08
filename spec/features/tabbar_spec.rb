require 'rails_helper'

describe 'Tabbar', type: :feature, js:true do
  let(:bob) { people(:bob) }

  GLOBAL_TABS =
    [
      { title: 'global.navbar.profile', path: "/%{locale}/people" },
      { title: 'global.navbar.skill_search', path: "/%{locale}/people_skills" },
      { title: 'global.navbar.cv_search', path: "/%{locale}/cv_search" },
      { title: 'global.navbar.skillset', path: "/%{locale}/skills" }
    ]

  PERSON_TABS =
    [
      { title: 'people.global.tabbar.cv', path: "/%{locale}/people/%{id}" },
      { title: 'people.global.tabbar.skills', path: "/%{locale}/people/%{id}/people_skills" }
    ]

  [:de, :en, :it, :fr].each do |locale|
    describe "Check if tabbar works for #{locale}" do

      before(:each) do
        sign_in auth_users(:admin)
        I18n.locale = locale
        default_url_options[:locale] = locale

        visit people_path
      end

      after(:each)  do
        expect(current_path).to start_with("/#{locale}")
      end

      describe 'Global' do
        GLOBAL_TABS.each do |hash|
          let(:path) { hash[:path] % { locale: locale } }
          let(:title) { t hash[:title] }

          it "Should highlight '#{hash[:title]}' tab using click" do
            click_link(href: path)
            check_highlighted_tab(title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit (path)
            check_highlighted_tab(title)
          end
        end

        def check_highlighted_tab(text)
          expect(page).to have_selector("div.skills-navbar .btn .nav-link.active", text: text)
        end
      end

      describe 'Person' do
        PERSON_TABS.each do |hash|
          let(:path) { hash[:path] % { id: bob.id, locale: locale } }
          let(:title) { t hash[:title] }

          it "Should highlight '#{hash[:title]}' tab using dropdown" do
            visit people_path
            select_from_slim_select("#person_id_person", bob.name)
            check_highlighted_tab("CV")
            click_link(href: path)
            check_highlighted_tab(title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit (path)
            check_highlighted_tab(title)
          end
        end

        def check_highlighted_tab(text)
          expect(page).to have_selector(".nav.nav-tabs .btn .nav-link.active", text: text)
        end
      end
    end
  end
end
