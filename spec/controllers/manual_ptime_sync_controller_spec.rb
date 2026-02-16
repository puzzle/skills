require 'rails_helper'

describe Admin::ManualPtimeSyncController, type: :controller do
  it 'should redirect to admin index when ptime_sync is inactive' do
    sign_in(auth_users(:conf_admin))
    allow(Skills).to receive(:use_ptime_sync?).and_return(false)

    get :index

    expect(response).to redirect_to(admin_index_path)
  end

  it 'should redirect to root when user is not conf admin' do
    sign_in(auth_users(:user))
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)

    get :index

    expect(response).to redirect_to(root_path)
  end
end
