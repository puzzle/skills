require 'rails_helper'

describe OmniauthCallbacksController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:auth_user]
  end

  describe '#keycloak_openid' do
    context 'when user has the required role' do
      before do
        allow(AuthConfig).to receive(:relevant_keycloak_role).and_return('puzzle')
        request.env['omniauth.auth'] = mock_omniauth_user(['puzzle'])
        get :keycloak_openid
      end

      it 'signs in the user' do
        expect(subject.current_auth_user).not_to be_nil
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user does not have the required role' do
      before do
        allow(AuthConfig).to receive(:relevant_keycloak_role).and_return('puzzle')
        request.env['omniauth.auth'] = mock_omniauth_user(['another_role'])
        get :keycloak_openid
      end

      it 'does not sign in the user' do
        expect(subject.current_auth_user).to be_nil
      end

      it 'redirects to the auth_error path' do
        expect(response).to redirect_to('/auth_error')
      end
    end
  end
end
