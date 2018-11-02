# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthdate        :datetime
#  language         :string
#  location         :string
#  martial_status   :string
#  updated_by       :string
#  name             :string
#  origin           :string
#  role             :string
#  title            :string
#  origin_person_id :integer
#  variation_name   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string
#  picture          :string
#  competences      :string
#


require 'rails_helper'

describe Person do
  fixtures :people

  context 'search' do
    it 'finds search term in associated education' do
      people = Person.search('duckduck')
      expect(people.count).to eq(1)
      expect(people.first.name).to eq('Bob Anderson')
    end

    it 'finds search term in person' do
      people = Person.search('Alice')
      expect(people.count).to eq(1)
      expect(people.first.name).to eq('Alice Mante')
    end
  end

  context 'variations' do
    before do
      @bob = people(:bob)
      @bobs_variation = Person::Variation.create_variation('bobs_variation1', @bob.id)
    end

#    it 'deletes all variations from a person' do
#      expect(Person.find_by(name: 'Bob Anderson')).to eq(@bob)
#      expect(Person.find_by(variation_name: 'bobs_variation1')).to eq(@bobs_variation)
#
#      @bob.destroy
#
#      expect(Person.find_by(name: 'Bob Anderson')).to eq(nil)
#      expect(Person.find_by(variation_name: 'bobs_variation1')).to eq(nil)
#    end

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

        expect(person.errors[:birthdate].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:language].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:location].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:name].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:origin].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:role].first).to eq('muss ausgefüllt werden')
        expect(person.errors[:title].first).to eq('muss ausgefüllt werden')
      end

      it 'should not be more than 100 characters' do
        person = people(:bob)
        person.location = SecureRandom.hex(100)
        person.language = SecureRandom.hex(100)
        person.martial_status = SecureRandom.hex(100)
        person.name = SecureRandom.hex(100)
        person.origin = SecureRandom.hex(100)
        person.role = SecureRandom.hex(100)
        person.title = SecureRandom.hex(100)
        person.variation_name = SecureRandom.hex(100)
        person.valid?

        expect(person.errors[:location].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:martial_status].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:origin].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:role].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:title].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:variation_name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
        expect(person.errors[:language].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      end
    end
  end
end
