require 'rails_helper'

describe Person::Variation do

  context 'variations' do

    let(:bob) { people(:bob) }
    let(:bobs_variation) { Person::Variation.create_variation('bobs_variation', bob.id) }

    it 'creates new variation for bob' do
      expect(bobs_variation.origin_person).to eq(bob)
      expect(bob.reload.variations.count).to eq(1)
    end

  end
end
