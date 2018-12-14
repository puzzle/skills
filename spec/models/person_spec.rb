# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  location                :string
#  marital_status          :string
#  updated_by              :string
#  name                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competences             :string
#  company_id              :bigint(8)
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#

require 'rails_helper'

describe Person do
  fixtures :people

  let(:bob) { people(:bob) }

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

  context 'validations' do
    context 'nationality' do

      it 'does not accept non country code' do
        bob.nationality = 'Schwizerland'
        bob.nationality2 = 'Germany'
        expect(bob).not_to be_valid
        expect(bob.errors.messages[:nationality].first).to eq('ist kein gültiger Wert')
        expect(bob.errors.messages[:nationality2].first).to eq('ist kein gültiger Wert')
      end

      it 'nationality has to be defined' do
        bob.nationality = nil
        expect(bob).not_to be_valid
        expect(bob.errors.messages[:nationality].first).to eq('muss ausgefüllt werden')
      end

      it 'accepts valid iso country code' do
        bob.nationality = 'CA'
        bob.nationality2 = nil
        expect(bob).to be_valid
      end

      it 'accepts blank value for second nationality' do
        bob.nationality = 'AT'
        bob.nationality2 = nil
        expect(bob).to be_valid
      end
    end

    it 'should not be more than 100 characters' do
      person = people(:bob)
      person.location = SecureRandom.hex(100)
      person.name = SecureRandom.hex(100)
      person.title = SecureRandom.hex(100)
      person.valid?

      expect(person.errors[:location].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      expect(person.errors[:name].first).to eq('ist zu lang (mehr als 100 Zeichen)')
      expect(person.errors[:title].first).to eq('ist zu lang (mehr als 100 Zeichen)')
    end
  end
end
