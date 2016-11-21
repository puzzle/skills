require 'rails_helper'

describe StatusesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all statuses' do
      process :index, method: :get

      statuses = json['statuses']
      expect(statuses.count).to eq(2)
      expect(statuses.first.count).to eq(2)
      expect(statuses.first).to include('status')
    end
  end

  describe 'GET show' do
    it 'returns status for specific id' do
      status = statuses(:employee)

      process :show, method: :get, params: { id: status.id }

      status_json = json['status']

      expect(status_json['status']).to eq(status.status)
    end
  end
end
