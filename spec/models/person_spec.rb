require 'rails_helper'

describe Person do
  fixtures :people
  
  context 'variations' do
    before do
      @bob = people(:bob)
      @alice = people(:alice)
    end
    it 'returns origin Person if origin_person_id is set' do
      @bob.origin_person_id = @alice.id
      expect(@bob.origin_person.id).to eq(@alice.id)
    end

    it 'returns all variations from a person' do
      p = Person.find(@bob.id)
      p.origin_person_id = @alice.id
      p.save

      expect(@alice.variations.count).to eq(1)
      expect(@alice.variations.first.id).to eq(@bob.id)
    end
  end
end
