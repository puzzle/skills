require 'rails_helper'

describe OffersController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all offers' do
      keys = %w(category offer)

      process :index, method: :get, params: { type: 'Company', company_id: firma.id }

      offers = json['data']

      expect(offers.count).to eq(1)
      expect(offers.first['attributes'].count).to eq(2)
      json_object_includes_keys(offers.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns offers' do
      offer = offers(:technologien)

      process :show, method: :get, params: { type: 'Company', company_id: firma.id, id: offer.id }

      offer_attrs = json['data']['attributes']

      expect(offer_attrs['category']).to eq(offer.category)
      expect(offer_attrs['offer']).to eq(offer.offer)
    end
  end

  describe 'POST create' do
    it 'creates new offer' do
      offer = { category: 'Datenbanken', offer: ['Mongo DB', 'PostgreSQL']}

      post :create, params: create_params(offer, firma.id, 'offer')

      new_offer = Offer.find_by(category: 'Datenbanken')
      expect(new_offer).not_to eq(nil)
      expect(new_offer.category).to eq('Datenbanken')
      expect(new_offer.offer).to eq(['Mongo DB', 'PostgreSQL'])
    end
  end

  describe 'PUT update' do
    it 'updates existing company' do
      offer = offers(:technologien)
      updated_attributes = { category: 'Werkzeuge' }

      process :update, method: :put, params: update_params(offer.id,
                                                           updated_attributes,
                                                           firma.id, 'offer')
      offer.reload
      expect(offer.category).to eq('Werkzeuge')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing company' do
      offer = offers(:technologien)
      process :destroy, method: :delete, params: {
        type: 'Company', company_id: firma.id, id: offer.id
      }

      expect(Offer.exists?(offer.id)).to eq(false)
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