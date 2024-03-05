require 'rails_helper'

describe :auth do
  describe 'Check authentications', type: :feature, js: true do


    describe 'Check user privileges' do

      before(:each) do
        user = auth_users(:user)
        login_as(user, scope: :auth_user)
      end

      it 'redirect to the first entry ' do
        visit people_path
        within 'section[data-controller="dropdown"]' do
          first('#person_id option:enabled', minimum: 1).select_option
        end
        expect(page).to have_current_path(person_path(list.first))
        expect(page).to have_select('person_id', selected: list.first.name)
      end
    end


    describe 'Check admin privileges' do

      before(:each) do
        user = auth_users(:admin)
        login_as(user, scope: :auth_user)
      end

      it 'redirect to the first entry ' do
        visit people_path
        within 'section[data-controller="dropdown"]' do
          first('#person_id option:enabled', minimum: 1).select_option
        end
        expect(page).to have_current_path(person_path(list.first))
        expect(page).to have_select('person_id', selected: list.first.name)
      end
    end


  end
end
