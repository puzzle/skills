require 'rails_helper'

describe Person do
  fixtures :people

  context 'fomatting' do
    it 'just one year if year from and to are the same' do
      bob = people(:bob)
      activity = bob.activities.first
      activity.update_attributes(year_to: 2000)
      
      formatted_year = bob.send(:formatted_year, activity)
      
      expect(formatted_year).to eq(2000)
    end

    it 'returns year from and to are not the same' do
      bob = people(:bob)
      activity = bob.activities.first
      
      formatted_year = bob.send(:formatted_year, activity)
      
      expect(formatted_year).to eq('2000 - 2010')
    end
  end

  context 'variations' do
    before do
      @bob = people(:bob)
      @alice = people(:alice)
      @bobs_variation = Person::Variation.create_variation('bobs_variation1', @bob.id)
    end
    it 'returns origin Person if origin_person_id is set' do
      expect(@bobs_variation.origin_person.id).to eq(@bob.id)
    end

    it 'returns all variations from a person' do
      expect(@bob.variations.count).to eq(1)
      expect(@bob.variations.first.origin_person_id).to eq(@bob.id)
    end
  end
end
