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
