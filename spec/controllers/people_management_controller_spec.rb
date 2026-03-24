require 'rails_helper'

describe Admin::PeopleManagementController, type: :controller do
  before(:each) do
    sign_in(auth_users(:conf_admin))
  end

  describe 'entries' do
    it 'should only use unemployed people when sync is disabled' do
      allow(Skills).to receive(:use_ptime_sync?).and_return(false)

      get :index

      expect(response.status).to eq(200)
      expect(assigns(:list_entries)).to eq(assigns(:unemployed_people))
      expect(assigns(:list_entries)).not_to be_nil
    end

    it 'should combine both lists when sync is enabled' do
      enable_ptime_sync

      get :index

      combined_list = assigns(:unemployed_people).or(assigns(:not_synced_profiles))

      expect(response.status).to eq(200)
      expect(assigns(:list_entries)).to eq(combined_list)
      expect(assigns(:list_entries)).not_to be_nil
    end
  end
end