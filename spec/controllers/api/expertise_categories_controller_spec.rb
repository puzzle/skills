require 'rails_helper'

describe Api::ExpertiseCategoriesController do

  describe 'GET index' do
    it 'returns all expertise categories for discipline' do
      keys = %w(name discipline)

      process :index, method: :get, params: { discipline: 'development' }

      categories = json['data']

      expect(categories.count).to eq(1)
      expect(categories.first['attributes'].count).to eq(2)
      json_object_includes_keys(categories.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns expertise_category' do
      expertise_category = expertise_categories(:ruby)

      process :show, method: :get, params: { id: expertise_category.id }

      expertise_category_attrs = json['data']['attributes']

      expect(expertise_category_attrs['name']).to eq(expertise_category.name)
    end
  end

  describe 'POST create' do
    it 'creates new expertise_category' do
      expertise_category = { name: 'new_category',
                             discipline: 'development' }

      post :create, params: { data: { attributes: expertise_category } }

      new_expertise_category = ExpertiseCategory.find_by(name: 'new_category')
      expect(new_expertise_category).not_to eq(nil)
      expect(new_expertise_category.development?).to be true
    end
  end

  describe 'PUT update' do
    it 'updates existing expertise_category' do
      expertise_category = expertise_categories(:ruby)
      updated_attributes = { name: 'changed' }

      process :update, method: :put, params: update_params(expertise_category.id, updated_attributes)

      expertise_category.reload
      expect(expertise_category.name).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing expertise_category' do
      expertise_category = expertise_categories(:ruby)
      process :destroy, method: :delete, params: { id: expertise_category.id }

      expect(ExpertiseCategory.exists?(expertise_category.id)).to be false
    end
  end

  private

  def update_params(object_id, updated_attributes)
    { data: { id: object_id,
              attributes: updated_attributes},
      id: object_id }
  end

end
