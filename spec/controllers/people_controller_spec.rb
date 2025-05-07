require 'rails_helper'

describe PeopleController do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end
  describe 'Update Person' do
    render_views
    let(:person) { people(:bob).attributes }

    it 'should save nationality2 as nil if checkbox is unchecked and save it if it is checked' do
      expect(person["nationality2"]).not_to be(nil)
      put :update, params: {id: person["id"], person: person, has_nationality2: {checked: "0"}}
      expect(response.code).to eq("302")
      expect(response).to redirect_to(person_path(person["id"]))
      expect(people(:bob).reload.nationality2).to be(nil)

      edited_person = person
      edited_person["nationality2"] = "DE"
      put :update, params: {id: person["id"], person: edited_person, has_nationality2: {checked: "1"}}
      expect(response.code).to eq("302")
      expect(response).to redirect_to(person_path(person["id"]))
      expect(people(:bob).reload.nationality2).to eql("DE")
    end
  end

  describe 'PuzzleTime sync' do
    it 'should redirect to new index path when ptime sync is active and new route is visited' do
      get :new
      expect(response.code).to eql('200')

      enable_ptime_sync

      get :new
      expect(response).to redirect_to(root_path)
    end
  end
end