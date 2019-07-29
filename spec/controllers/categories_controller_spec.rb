require 'rails_helper'

describe CategoriesController do
  describe 'CategoriesController' do

    describe 'GET index' do
      it 'returns all categories' do
        keys = %w[title parent_id]

        get :index

        categories = json['data']

        expect(categories.count).to eq(5)
        java_attrs = categories.third['attributes']
        expect(java_attrs.count).to eq (3)
        expect(java_attrs['title']).to eq ('Java')
        json_object_includes_keys(java_attrs, keys)
      end

      it 'returns only parents if param present' do
        keys = %w[title parent_id]

        get :index, params: { scope: 'parents' }

        categories = json['data']

        expect(categories.count).to eq(2)
        category_titles = categories.map { |c| c['attributes']['title'] }
        expect(category_titles).to include('Software-Engineering')
        expect(category_titles).to include('System-Engineering')
        software_engineering_attrs = categories.second['attributes']
        expect(software_engineering_attrs.count).to eq (3)
        expect(software_engineering_attrs['parent_id']).to eq (nil)
        json_object_includes_keys(software_engineering_attrs, keys)
      end
    end
  end
end
