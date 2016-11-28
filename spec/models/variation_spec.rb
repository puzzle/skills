require 'rails_helper'

describe Person::Variation do
  fixtures :people

  context 'variations' do
    before do
      @bob = people(:bob)
      @bobs_variation = Person::Variation.create_variation('bobs_variation', @bob.id)
    end
    it 'returns origin Person if origin_person_id is set' do
      expect(@bobs_variation.origin_person_id).to eq(@bob.id)
    end

    it 'returns all variations from a person' do
      expect(@bob.variations.count).to eq(1)
      expect(@bob.variations.first.origin_person_id).to eq(@bob.id)
    end
  end
end
