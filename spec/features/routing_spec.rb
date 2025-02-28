require 'rails_helper'

describe 'Routing', type: :feature, js: true do

  let(:bob) { people(:bob) }

  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  describe "Check auto rerouting" do
    ROUTES = {
      "/": "/people",
      "/de/": "/people",
      "/people": "/people",
      "/people_skills": "/people_skills",
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
        select 'Italiano', from: "i18n_language"
        default_url_options[:locale] = :it
      end

      it "Should open profile with correct language" do
        select_from_slim_select("#person_id_person", bob.name)
        expect(page).to have_text("Dati personali")
        click_link(href: person_people_skills_path(bob))
        expect(page).to have_text("Nuove competenze per la valutazione")
      end
    end
  end
end
