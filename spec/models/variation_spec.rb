require 'rails_helper'

describe Person::Variation do

  context 'variations' do

    let(:bob) { people(:bob) }
    let(:bobs_variation) { Person::Variation.create_variation('bobs_variation', bob.id) }

    it 'creates new variation for bob' do
      expect(bobs_variation.origin_person).to eq(bob)
      expect(bob.reload.variations.count).to eq(1)
    end

    it 'renders validation errors if person has invalid nested values' do
      bob = people(:bob)
      bob.educations.first.update_column(:title, nil)
      bob.reload

      assert_raises ActiveRecord::RecordInvalid do
        Person::Variation.create_variation('bobs_invalid_variation', bob.id)
      end
    end
  end
end
