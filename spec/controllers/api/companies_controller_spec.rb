require 'rails_helper'

describe Api::CompaniesController do
  describe 'CompaniesController' do

    describe 'GET index' do
      it 'returns all companies without nested models without any filter' do
        keys = %w(name)

        get :index

        companies = json['data']

        expect(companies.count).to eq(2)
        firma_attrs = companies.first['attributes']
        expect(firma_attrs.count).to eq(3)
        expect(firma_attrs.first[1]).to eq('Firma')
        json_object_includes_keys(firma_attrs, keys)
        expect(companies).not_to include('relationships')
      end
    end

    describe 'POST create' do
      it 'creates new company' do
        company = {name: 'firma123'}

        process :create, method: :post, params: { data: { attributes: company } }

        new_company = Company.find_by(name: 'firma123')
        expect(new_company).not_to eq(nil)
      end
    end

    describe 'PUT update' do
      it 'updates existing company' do
        firma = companies(:firma)

        process :update, method: :put, params: {
          id: firma.id, data: { attributes: { name: 'Wue' } }
        }

        firma.reload
        expect(firma.name).to eq('Wue')
      end
    end

    describe 'DELETE destroy' do
      it 'destroys existing company' do
        firma = companies(:partner)
        process :destroy, method: :delete, params: { id: firma.id }

        expect(Company.exists?(firma.id)).to eq(false)
      end
    end
  end
end
