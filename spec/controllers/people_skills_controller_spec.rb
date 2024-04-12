require 'rails_helper'

describe PeopleSkillsController do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  describe 'Update Person' do
    let(:skill) { skills(:rails).attributes }
    render_views

    it 'should return matching entries' do
      get :index, params: {skill_id: skill["id"], level: 1, interest: 1}
      expect(response.code).to eq("200")
      # expect(response.body).to redirect_to(person_path(person["id"]))
    end
  end
end