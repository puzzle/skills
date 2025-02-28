require 'rails_helper'

describe 'Tabbar', type: :feature, js:true do
  let(:bob) { people(:bob) }

  GLOBAL_TABS =
    [
      { title: 'global.navbar.profile', path_helper: "people_path" },
      { title: 'global.navbar.skill_search', path_helper: "people_skills_path" },
      { title: 'global.navbar.cv_search', path_helper: "cv_search_index_path" },
      { title: 'global.navbar.skillset', path_helper: "skills_path" }
    ]

  PERSON_TABS =
    [
      { title: 'people.global.tabbar.cv', path_helper: "person_path" },
      { title: 'people.global.tabbar.skills', path_helper: "person_people_skills_path" }
    ]

  [:de, :en, :it, :fr].each do |locale|
    describe "Check if tabbar works for #{locale}" do

      before(:each) do
        sign_in auth_users(:admin)
        I18n.locale = locale
        default_url_options[:locale] = I18n.locale == I18n.default_locale ? nil : I18n.locale

        visit people_path
      end

      after(:each) do
        expect(current_path.start_with?("/#{locale}")).to eq(I18n.locale != I18n.default_locale)
      end

      describe 'Global' do
        GLOBAL_TABS.each do |hash|
          let(:path_helper) { hash[:path_helper] }
          let(:title) { t hash[:title] }

          it "Should highlight '#{hash[:title]}' tab using click" do
            click_link(href: eval(path_helper))
            check_highlighted_tab(title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit eval(path_helper)
            check_highlighted_tab(title)
          end
        end

        def check_highlighted_tab(text)
          expect(page).to have_selector("div.skills-navbar .btn .nav-link.active", text: text)
        end
      end

      describe 'Person' do
        PERSON_TABS.each do |hash|
          let(:path_helper) { hash[:path_helper] }
          let(:title) { t hash[:title] }

          it "Should highlight '#{hash[:title]}' tab using dropdown" do
            visit people_path
            select_from_slim_select("#person_id_person", bob.name)
            check_highlighted_tab("CV")
            click_link(href: eval("#{path_helper} #{bob.id}"))
            check_highlighted_tab(title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit eval("#{path_helper} #{bob.id}")
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
