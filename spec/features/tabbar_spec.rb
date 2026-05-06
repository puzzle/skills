require 'rails_helper'

describe 'Tabbar', type: :feature, js:true do
  let(:bob) { people(:bob) }

  GLOBAL_TABS =
    [
      { title: 'global.navbar.profile', path_helper: "people_path", admin_only: false },
      { title: 'global.navbar.skill_search', path_helper: "skill_search_index_path", admin_only: false },
      { title: 'global.navbar.cv_search', path_helper: "cv_search_index_path", admin_only: false },
      { title: 'global.navbar.skillset', path_helper: "skills_path", admin_only: false },
      { title: 'global.navbar.certificates', path_helper: "certificates_path", admin_only: true },
      { title: 'global.navbar.skills_tracking', path_helper: "department_skill_snapshots_path", admin_only: false }
    ]

  PERSON_TABS =
    [
      { title: 'people.global.tabbar.cv', path_helper: "person_path", admin_only: false },
      { title: 'people.global.tabbar.skills', path_helper: "person_people_skills_path", admin_only: false }
    ]

  [:de, :en, :it, :fr].each do |locale|
    describe "Check if tabbar works for #{locale}" do

      before(:each) do
        I18n.locale = locale
        default_url_options[:locale] = I18n.locale
      end

      after(:each) do
        expect(current_path).to start_with("/#{locale}/")
      end

      describe 'Global' do
        before(:each) do
          sign_in auth_users(:admin)
          visit people_path
        end

        GLOBAL_TABS.each do |hash|
          path_helper = hash[:path_helper]
          title = hash[:title]

          it "Should highlight '#{hash[:title]}' tab using click" do
            click_link(href: eval(path_helper))
            check_highlighted_tab(t title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit eval(path_helper)
            check_highlighted_tab(t title)
          end
        end

        def check_highlighted_tab(text)
          expect(page).to have_selector("div.skills-navbar .btn .nav-link.active", text: text)
        end
      end

      describe 'Person' do
        before(:each) do
          sign_in auth_users(:admin)
          visit people_path
        end

        PERSON_TABS.each do |hash|
          path_helper = hash[:path_helper]
          title = hash[:title]

          it "Should highlight '#{hash[:title]}' tab using dropdown" do
            visit people_path
            select_from_slim_select("#person_id_person", bob.name)
            check_highlighted_tab("CV")
            click_link(href: eval("#{path_helper} #{bob.id}"))
            check_highlighted_tab(t title)
          end

          it "Should highlight '#{hash[:title]}' tab after visit by url" do
            visit eval("#{path_helper} #{bob.id}")
            check_highlighted_tab(t title)
          end
        end

        def check_highlighted_tab(text)
          expect(page).to have_selector(".nav.nav-tabs .btn .nav-link.active", text: text)
        end
      end

      describe 'Check visibility of admin only tabs' do
        before(:each) do
          sign_in auth_users(:user)
          visit people_path
        end

        GLOBAL_TABS.each do |hash|
          title = hash[:title]
          admin_only = hash[:admin_only]

          it "should #{'not' if admin_only} display #{title} tab as user" do
            expect(page.has_selector?("div.skills-navbar .btn", text: (t title), wait: 0.1)).to eql(!admin_only)
          end
        end

        PERSON_TABS.each do |hash|
          path_helper = hash[:path_helper]
          title = hash[:title]
          admin_only = hash[:admin_only]

          it "should #{'not' if admin_only} display #{title} tab on profile as user" do
            visit eval("#{path_helper} #{bob.id}")
            expect(page.has_selector?(".nav.nav-tabs .btn", text: (t title), wait: 0.1)).to eql(!admin_only)
          end
        end
      end
    end
  end
end
