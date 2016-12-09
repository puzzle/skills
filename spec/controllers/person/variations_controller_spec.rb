require 'rails_helper'

describe Person::VariationsController do
  context 'variations' do
    before do
      @bob = people(:bob)
      @bobs_variation1 = Person::Variation.create_variation('bobs_variation1', @bob.id)
      @bobs_variation2 = Person::Variation.create_variation('bobs_variation2', @bob.id)
      auth(:ken)
    end

    describe 'GET index' do
      it 'returns all person variations without nested models' do
        keys =  %w(birthdate picture language location martial-status
                   updated-by name origin role title variation-name)

        process :index, method: :get, params: { person_id: @bob.id }

        variations = json['data']

        expect(variations.count).to eq(2)
        expect(variations.first['attributes'].count).to eq(11)
        expect(variations.first['attributes']['variation-name']).to eq('bobs_variation1')
        json_object_includes_keys(variations.first['attributes'], keys)
      end
    end

    describe 'GET show' do
      it 'returns person variations with nested modules' do
        keys =  %w(birthdate picture language location martial-status updated-by name origin
                   role title variation-name )

        process :show, method: :get, params: { person_id: @bob.id,
                                               id: @bobs_variation1.id }

        bob_attrs = json['data']['attributes']

        expect(bob_attrs.count).to eq(11)
        json_object_includes_keys(bob_attrs, keys)
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

    describe 'PUT update' do
      it 'updates existing person variation' do
        process :update, method: :put, params: { person_id: @bob.id,
                                                 id: @bobs_variation1.id,
                                                 person_variation: { location: 'test_location' } }

        @bobs_variation1.reload

        expect(@bobs_variation1.location).to eq('test_location')
      end
    end

    describe 'DELETE destroy' do
      it 'destroys existing person variation' do
        process :destroy, method: :delete, params: { person_id: @bob.id, id: @bobs_variation2.id }

        expect(Person::Variation.exists?(@bobs_variation2.id)).to eq(false)
        expect(Activity.exists?(person_id: @bobs_variation2.id)).to eq(false)
        expect(AdvancedTraining.exists?(person_id: @bobs_variation2.id)).to eq(false)
        expect(Project.exists?(person_id: @bobs_variation2.id)).to eq(false)
        expect(Education.exists?(person_id: @bobs_variation2.id)).to eq(false)
        expect(Competence.exists?(person_id: @bobs_variation2.id)).to eq(false)
      end
    end
  end
end
