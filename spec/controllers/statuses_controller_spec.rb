require 'rails_helper'

describe StatusesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all statuses' do
      process :index, method: :get

      statuses = json['data']
      expect(statuses.count).to eq(2)
      expect(statuses.first['attributes'].count).to eq(1)
      expect(statuses.first['attributes']).to include('status')
    end
  end

  describe 'GET show' do
    it 'returns status for specific id' do
      status = statuses(:employee)

      process :show, method: :get, params: { id: status.id }

      status_json = json['data']

      expect(status_json['attributes']['status']).to eq(status.status)
    end
  end
end
