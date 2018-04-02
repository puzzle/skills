require 'rails_helper'

describe EmployeeQuantitiesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all employee quantities' do
      keys = %w(category quantity)

      process :index, method: :get, params: { type: 'Company', company_id: firma.id }

      employee_quantities = json['data']

      expect(employee_quantities.count).to eq(1)
      expect(employee_quantities.first['attributes'].count).to eq(2)
      json_object_includes_keys(employee_quantities.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns employee quantities' do
      employee_quantity = employee_quantities(:entwicklung)

      process :show, method: :get, params: { type: 'Company', company_id: firma.id, id: employee_quantity.id }

      employee_quantity_attrs = json['data']['attributes']

      expect(employee_quantity_attrs['category']).to eq(employee_quantity.category)
      expect(employee_quantity_attrs['quantity']).to eq(employee_quantity.quantity)
    end
  end

  describe 'POST create' do
    it 'creates new employee quantity' do
      employee_quantity = { category: 'total', quantity: 40}

      post :create, params: create_params(employee_quantity, firma.id, 'employee_quantity')

      new_employee_quantity = EmployeeQuantity.find_by(category: 'total')
      expect(new_employee_quantity).not_to eq(nil)
      expect(new_employee_quantity.quantity).to eq(40)
    end
  end

  describe 'PUT update' do
    it 'updates existing employee quantity' do
      employee_quantity = employee_quantities(:entwicklung)
      updated_attributes = { quantity: 170 }

      process :update, method: :put, params: update_params(employee_quantity.id,
                                                           updated_attributes,
                                                           firma.id, 'employee_quantity')
      employee_quantity.reload
      expect(employee_quantity.quantity).to eq(170)
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing employee quantity' do
      employee_quantity = employee_quantities(:entwicklung)
      process :destroy, method: :delete, params: {
        type: 'Company', company_id: firma.id, id: employee_quantity.id
      }

      expect(EmployeeQuantity.exists?(employee_quantity.id)).to eq(false)
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