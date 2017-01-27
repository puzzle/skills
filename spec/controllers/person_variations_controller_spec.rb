require 'rails_helper'

describe PersonVariationsController do
  context 'variations' do
    before do
      @bob = people(:bob)
      @bobs_variation1 = Person::Variation.create_variation('bobs_variation1', @bob.id)
      @bobs_variation2 = Person::Variation.create_variation('bobs_variation2', @bob.id)
      auth(:ken)
    end

    describe 'GET index' do
      it 'returns all person variations without nested models' do

        process :index, method: :get, params: { person_id: @bob.id }

        variations = json['data']

        expect(variations.count).to eq(2)
        expect(variations.first['attributes'].count).to eq(1)
        expect(variations.first['attributes']['variation_name']).to eq('bobs_variation1')
      end
    end

    describe 'POST create' do
      it 'creates new person variation' do
        process :create, method: :post, params: { person_id: @bob.id,
                                                  variation_name: 'variation_test' }

        new_person_variation = @bob.variations.find_by(variation_name: 'variation_test')
        expect(new_person_variation.location).to eq(@bob.location)
        expect(new_person_variation.language).to eq(@bob.language)
        expect(new_person_variation.variation_name).to eq('variation_test')
        expect(new_person_variation.type).to eq('Person::Variation')
      end
    end
  end

  private

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                person: { data: { type: 'people',
                                  id: user_id } }
              }, type: model_type }, id: object_id }
  end
end
