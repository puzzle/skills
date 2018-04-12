require 'rails_helper'

describe CompaniesController do
  describe 'CompaniesController' do
    before { auth(:ken) }

    describe 'GET index' do
      it 'returns all companies without nested models without any filter' do
        keys = %w(name)

        get :index

        companies = json['data']

        expect(companies.count).to eq(2)
        firma_attrs = companies.first['attributes']
        expect(firma_attrs.count).to eq(13)
        expect(firma_attrs.first[1]).to eq('Firma')
        json_object_includes_keys(firma_attrs, keys)
        expect(companies).not_to include('relationships')
      end
    end

    describe 'GET show' do
      it 'returns company with nested modules' do
        keys = %w[name web email phone partnermanager contact_person email_contact_person
                  phone_contact_person crm level my_company]

        firma = companies(:firma)

        process :show, method: :get, params: { id: firma.id }

        firma_attrs = json['data']['attributes']

        expect(firma_attrs.count).to eq(13)
        json_object_includes_keys(firma_attrs, keys)

        nested_keys = %w(locations employee_quantities people)
        nested_attrs = json['data']['relationships']

        expect(nested_attrs.count).to eq(3)
        json_object_includes_keys(nested_attrs, nested_keys)
      end
    end

    describe 'POST create' do
      it 'creates new company' do
        company = {name: 'firma123', web: 'www.firma.123', email: 'info@firma.123', phone: '123',
                   partnermanager: 'Paul', contact_person: 'Felix',
                   email_contact_person: 'felix@firma.123', phone_contact_person: '123456',
                   crm: 'crm123', level: 'X', my_company: false}

        process :create, method: :post, params: { data: { attributes: company } }

        new_company = Company.find_by(name: 'firma123')
        expect(new_company).not_to eq(nil)
        expect(new_company.contact_person).to eq('Felix')
        expect(new_company.level).to eq('X')
      end
    end

    describe 'PUT update' do
      it 'updates existing company' do
        firma = companies(:firma)

        process :update, method: :put, params: {
          id: firma.id, data: { attributes: { partnermanager: 'Klaus' } }
        }

        firma.reload
        expect(firma.partnermanager).to eq('Klaus')
      end
    end

    describe 'DELETE destroy' do
      it 'destroys existing company which is not my company' do
        firma = companies(:partner)
        process :destroy, method: :delete, params: { id: firma.id }

        expect(Company.exists?(firma.id)).to eq(false)
        expect(Location.exists?(company_id: firma.id)).to eq(false)
        expect(EmployeeQuantity.exists?(company_id: firma.id)).to eq(false)
      end
      
      it 'does not destroy my company' do
        firma = companies(:firma)
        process :destroy, method: :delete, params: { id: firma.id }

        expect(Company.exists?(firma.id)).to eq(true)
        expect(Location.exists?(company_id: firma.id)).to eq(true)
        expect(EmployeeQuantity.exists?(company_id: firma.id)).to eq(true)
      end
    end   
  end

  private

  def update_params(object_id, updated_attributes, _user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              type: model_type },
      id: object_id }
  end


end