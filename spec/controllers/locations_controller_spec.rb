require 'rails_helper'

describe LocationsController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all locations' do
      keys = %w(location)

      process :index, method: :get, params: { type: 'Company', company_id: firma.id }

      locations = json['data']

      expect(locations.count).to eq(1)
      expect(locations.first['attributes'].count).to eq(1)
      json_object_includes_keys(locations.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns location' do
      location = locations(:bern)

      process :show, method: :get, params: { type: 'Company', company_id: firma.id, id: location.id }

      location_attrs = json['data']['attributes']

      expect(location_attrs['location']).to eq(location.location)
    end
  end

  describe 'POST create' do
    it 'creates new location' do
      location = { location: 'Basel'}

      post :create, params: create_params(location, firma.id, 'location')

      new_location = Location.find_by(location: 'Basel')
      expect(new_location).not_to eq(nil)
      expect(new_location.location).to eq('Basel')
    end
  end

  describe 'PUT update' do
    it 'updates existing company' do
      location = locations(:bern)
      updated_attributes = { location: 'genf' }

      process :update, method: :put, params: update_params(location.id,
                                                           updated_attributes,
                                                           firma.id, 'location')
      location.reload
      expect(location.location).to eq('genf')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing company' do
      location = locations(:bern)
      process :destroy, method: :delete, params: {
        type: 'Company', company_id: firma.id, id: location.id
      }

      expect(Location.exists?(location.id)).to eq(false)
    end
  end

  private

  def firma
    @firma ||= companies(:firma)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object,
              relationships: { company: { data: { type: 'Companies',
                                                 id: user_id } } }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                company: { data: { type: 'companies', id: user_id } }
              }, type: model_type }, id: object_id }
  end
end