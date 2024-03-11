require 'rails_helper'

describe PeopleController do
  describe 'Update Person' do
    render_views
    let(:person) { people(:bob).attributes }

    it 'should save nationality2 as nil if checkbox is unchecked and save it if it is checked' do
      put :update, params: {id: person["id"], person: person, has_nationality2: {checked: "0"}}

      response.code.should == "302"
      response.should redirect_to(person_path(person["id"]))

      expect(people(:bob).reload.nationality2).to be(nil)
    end
  end
end