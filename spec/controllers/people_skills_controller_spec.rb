require 'rails_helper'

describe PeopleSkillsController do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  describe 'Search people with skills' do
    render_views

    it 'should return matching entries' do
      get :index, params: {skill_id: skills(:rails).id, level: 1, interest: 1}
      expect(response.code).to eq("200")
      expect(response.body).to include("Bob Anderson")
      expect(response.body).to include()
    end

    it 'should return no results if skill id is not given' do
      get :index, params: {skill_id: nil, level: 1, interest: 1}
      expect(response.code).to eq("200")
      expect(response.body).to include("Keine Resultate")
    end
  end
end