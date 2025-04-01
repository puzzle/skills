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

    it 'should be able to update name' do
      testname = 'Test'
      expect(person["name"]).to eql('Bob Anderson')
      put :update, params: {id: person["id"], person: { name: testname } }
      expect(response).to redirect_to(person_path(person["id"]))
      expect(people(:bob).reload.name).to eql(testname)
    end

    it 'should not be able to update name' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(true)
      expect(person["name"]).to eql("Bob Anderson")
      expect {
        put :update, params: { id: person["id"], person: { name: 'Test' } }
      }.to raise_error(ActionController::ParameterMissing)
      expect(people(:bob).reload.name).to eql("Bob Anderson")
    end
  end
end