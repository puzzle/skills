require 'rails_helper'

describe Admin::UpdatePeopleController, type: :controller do

  before(:each) do
    sign_in(auth_users(:admin))
    allow(Skills).to receive(:use_ptime_sync?).and_return(true)
  end

  before do
    allow(NightlyUpdatePeopleDataPtimeJob).to receive(:perform_now)
                                                .and_return(['John Doe', 'Jane Smith'])
  end

  it 'sets flash alert with failed names' do
    post :manual_sync

    expect(flash[:alert]).to include('John Doe', 'Jane Smith')
    expect(response).to redirect_to(admin_update_people_path)
  end

  before do
    allow(NightlyUpdatePeopleDataPtimeJob).to receive(:perform_now)
                                                .and_return([])
  end

  it 'sets successful flash notice' do
    post :manual_sync

    expect(flash[:notice]).to eq(I18n.t('admin.update_people.manual_sync.people_updated'))
    expect(response).to redirect_to(admin_update_people_path)
  end

  before do
    allow(Skills).to receive(:use_ptime_sync?).and_return(false)
  end

  it 'redirects to admin index' do
    post :manual_sync

    expect(response).to redirect_to(admin_index_path)
  end
end
