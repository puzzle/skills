require 'rails_helper'

describe Person do
  fixtures :people

  context 'fomatting' do
    it 'returns just one year if year_from and year_to are the same' do
      bob = people(:bob)
      activity = bob.activities.first
      activity.update_attributes(year_to: 2000)

      formatted_year = bob.send(:formatted_year, activity)

      expect(formatted_year).to eq(2000)
    end

    it 'returns formatted year_from and year_to if they are not the same' do
      bob = people(:bob)
      activity = bob.activities.first

      formatted_year = bob.send(:formatted_year, activity)

      expect(formatted_year).to eq('2000 - 2010')
    end
  end

  context 'variations' do
    before do
      @bob = people(:bob)
      @bobs_variation = Person::Variation.create_variation('bobs_variation1', @bob.id)
    end
    it 'returns origin Person if origin_person_id is set' do
      expect(@bobs_variation.origin_person.id).to eq(@bob.id)
    end

    it 'returns all variations from a person' do
      expect(@bob.variations.count).to eq(1)
      expect(@bob.variations.first.origin_person_id).to eq(@bob.id)
    end

    context 'validations' do
      it 'checks whether required attribute values are present' do
        person = Person.new
        person.valid?

        expect(person.errors[:birthdate].first).to eq("can't be blank")
        expect(person.errors[:language].first).to eq("can't be blank")
        expect(person.errors[:location].first).to eq("can't be blank")
        expect(person.errors[:name].first).to eq("can't be blank")
        expect(person.errors[:origin].first).to eq("can't be blank")
        expect(person.errors[:role].first).to eq("can't be blank")
        expect(person.errors[:title].first).to eq("can't be blank")
        expect(person.errors[:status_id].first).to eq("can't be blank")
      end

      it 'should not be more than 50 characters' do
        person = people(:bob)
        person.location = SecureRandom.hex(50)
        person.martial_status = SecureRandom.hex(50)
        person.name = SecureRandom.hex(50)
        person.origin = SecureRandom.hex(50)
        person.role = SecureRandom.hex(50)
        person.title = SecureRandom.hex(50)
        person.variation_name = SecureRandom.hex(50)
        person.valid?

        expect(person.errors[:location].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:martial_status].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:name].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:origin].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:role].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:title].first).to eq('is too long (maximum is 50 characters)')
        expect(person.errors[:variation_name].first).to eq('is too long (maximum is 50 characters)')
      end

      it 'should not be more than 100 characters' do
        person = people(:bob)
        person.language = SecureRandom.hex(100)
        person.valid?

        expect(person.errors[:language].first).to eq('is too long (maximum is 100 characters)')
      end
    end
  end
end
