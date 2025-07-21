require 'rails_helper'

describe 'Routing', type: :feature, js: true do

  let(:bob) { people(:bob) }

  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  describe "Check auto rerouting" do
    ROUTES = {
      "/": "/de/people",
      "/de/": "/de/people",
      "/people": "/de/people",
      "/skill_search": "/de/skill_search",
      "/en": "/en/people",
    }

    ROUTES.each do |url, target|
      it "Should route from '#{url}' to #{target}" do
          visit url
          expect(current_path).to eq(target)
      end
    end
  end

  describe "Check if language is applied correctly" do
    context "Set locale via dropdown" do
      before(:each) do
        visit people_path
      end

      it "Should open profile with correct language and preserve language in cookie" do
        select 'Italiano', from: "i18n_language"

        select_from_slim_select("#person_id_person", bob.name)
        expect(page).to have_text("Dati personali")

        # Visiting page with locale explicitly defined in route should use locale from route
        visit '/en/'
        select_from_slim_select("#person_id_person", bob.name)
        expect(page).to have_text("Personal details")

        # Simulate revisit without a locale in the url, which should use locale from cookie
        visit '/'

        select_from_slim_select("#person_id_person", bob.name)
        expect(page).to have_text("Dati personali")
        click_link(href: person_people_skills_path(bob, locale: :it))
        expect(page).to have_text("Nuove competenze per la valutazione")
      end
    end
  end
end
