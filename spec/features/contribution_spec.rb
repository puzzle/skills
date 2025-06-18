require 'rails_helper'

describe 'Contributions', type: :feature, js:true do
  let(:person) { people(:bob) }

  before(:each) do
    sign_in auth_users(:admin)
    visit person_path(person)
  end

  describe 'Crud actions' do
    it 'shows all' do
      within('turbo-frame#contribution') do
        person.contributions.each do |contribution|
          expect(page).to have_content(contribution.title)
          expect(page).to have_content(contribution.reference)
        end
      end
    end
  end
end