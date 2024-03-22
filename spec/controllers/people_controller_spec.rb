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

    it 'should save valid language levels and replace invalid language levels with keine' do
      valid_language_skill = language_skills(:deutsch)

      person["language_skills_attributes"] = {"0" => valid_language_skill.attributes}
      put :update, params: {id: person["id"], person: person}
      response.code.should == "302"
      response.should redirect_to(person_path(person["id"]))
      expect(people(:bob).reload.language_skills[0]).to eql(valid_language_skill)

      invalid_language_skill = valid_language_skill
      invalid_language_skill.level = "Some random nonsense"

      person["language_skills_attributes"] = {"0" => invalid_language_skill.attributes}
      put :update, params: {id: person["id"], person: person}
      response.code.should == "302"
      response.should redirect_to(person_path(person["id"]))
      expect(people(:bob).reload.language_skills.last.level).to eql("Keine")
    end
  end
end