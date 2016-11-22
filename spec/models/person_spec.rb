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
      it 'presence true' do
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

      it 'max length should be 30' do
        person = people(:bob)
        person.location = SecureRandom.hex(30)
        person.martial_status = SecureRandom.hex(30)
        person.updated_by = SecureRandom.hex(30)
        person.name = SecureRandom.hex(30)
        person.origin = SecureRandom.hex(30)
        person.role = SecureRandom.hex(30)
        person.title = SecureRandom.hex(30)
        person.variation_name = SecureRandom.hex(30)
        person.valid?

        expect(person.errors[:location].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:martial_status].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:updated_by].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:name].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:origin].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:role].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:title].first).to eq('is too long (maximum is 30 characters)')
        expect(person.errors[:variation_name].first).to eq('is too long (maximum is 30 characters)')
      end

      it 'max length should be 100' do
        person = people(:bob)
        person.language = SecureRandom.hex(100)
        person.valid?

        expect(person.errors[:language].first).to eq('is too long (maximum is 100 characters)')
      end
    end
  end
end
