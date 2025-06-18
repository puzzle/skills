require 'rails_helper'

describe SkillSearchController do
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  describe 'Search people with skills' do
    render_views

    it 'should return matching entries' do
      get :index, params: {"skill_id[]": skills(:rails).id, "level[]": 1, "interest[0]": 1}
      expect(response.code).to eq("200")
      expect(response.body).to include("Bob Anderson")
    end

    it 'should get results over url too' do
      query_params = {
        skill_id: [skills(:rails).id, skills(:bash).id, skills(:junit).id, skills(:cunit).id],
        level: [4, 5, 5, 5],
        "interest[0]": 5,
        "interest[1]": 2,
        "interest[2]": 3,
        "interest[3]": 2,
      }
      get :index, params: query_params

      expect(response.code).to eq("200")
      expect(response.body).to include("Wally Allround")
    end
  end
end
