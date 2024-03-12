require 'rails_helper'

describe StatusController, type: :controller do
  xdescribe 'Status Controller' do
    it 'returns successfully from /health' do
      get :health
      assert_response :success
      assert_match /ok/, response.body.to_s
    end

    it 'returns successfully from /readiness' do
      get :readiness
      assert_response :success
      assert_match /ok/, response.body.to_s
    end
  end
end
