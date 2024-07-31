require 'rails_helper'

describe 'Check routes', type: :feature, js: true do
  ROUTES = {
    "/": "/de/people",
    "/de/": "/de/people",
    "/people": "/de/people",
    "/people_skills": "/de/people_skills"
  }
  before(:each) do
    sign_in auth_users(:user), scope: :auth_user
  end

  ROUTES.each do |url, target|
    it "Should route from '#{url}' to #{target}" do
        visit url
        expect(current_path).to eq(target)
    end
  end
end
