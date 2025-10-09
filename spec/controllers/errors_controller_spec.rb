require 'rails_helper'

RSpec.describe ErrorsController, type: :request do
  describe 'GET #auth_error' do
    before { get '/auth_error' }

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'renders the auth_error template' do
      expect(response).to render_template(:auth_error)
    end

    it 'does not use the application layout' do
      expect(response.body).not_to include('<title>PuzzleSkills</title>')
    end

    it 'contains the correct error message' do
      expect(response.body).to include('You do not have the necessary permissions')
    end
  end
end
