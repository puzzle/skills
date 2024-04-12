require 'rails_helper'

describe :people_skills do
  describe 'People Search', type: :feature, js: true do
    let(:skill) { skills(:rails).attributes }

    before(:each) do
      sign_in auth_users(:user), scope: :auth_user
    end

    it 'Should return matching entries to page' do
      visit people_skills_path
      select skill["title"].to_s, from: 'skill_id'
      page.find(".star5").click(x: 10, y: 10)
      page.find("#level").set(3)
      expect(page).to have_text('Bob Anderson')
      expect(page).to have_text('Wally Allround')
    end

    it 'Should set values of query parameters' do
      visit(people_skills_path + "?skill_id=#{skill["id"]}&level=3&interest=5")
      expect(page).to have_select("skill_id", selected: "Rails")
      expect(page).to have_field("level", with: 3)
      expect(page).to have_field("interest", with: 5, visible: false)
    end

    it 'Should return no results if skill id is not set' do
      visit(people_skills_path + "?level=3&interest=5")
      expect(page).to have_field("level", with: 3)
      expect(page).to have_field("interest", with: 5, visible: false)
      expect(page).to have_text("Keine Resultate")
    end

  end
end
