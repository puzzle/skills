# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  location                :string
#  updated_by              :string
#  name                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competence_notes        :string
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#  marital_status          :integer          default("single"), not null
#  email                   :string
#  department_id           :integer
#

require 'rails_helper'

describe Person do
  fixtures :people

  let(:bob) { people(:bob) }

  context 'search' do
    it 'finds search term in associated project' do
      people = Person.search('duckduck')
      expect(people.count).to eq(1)
      expect(people.first.name).to eq('Bob Anderson')
    end

    it 'finds search term in person' do
      people = Person.search('Alice')
      expect(people.count).to eq(1)
      expect(people.first.name).to eq('Alice Mante')
    end

    context 'found in' do
      it 'finds in which association the search term has been found' do
        search_term = 'duckduck'
        people = Person.search(search_term)
        person = people[0]
        person = Person.includes(:department, :roles, :projects, :activities,
                                 :educations, :advanced_trainings, :expertise_topics)
                       .find(person.id)
        expect(person.found_in(search_term)).to eq('projects#title')
      end

      it 'finds in which person attribute the search term has been found' do
        search_term = 'Alice'
        people = Person.search(search_term)
        person = people[0]
        person = Person.includes(:department, :roles, :projects, :activities,
                                 :educations, :advanced_trainings, :expertise_topics)
                       .find(person.id)
        expect(person.found_in(search_term)).to eq('name')
      end

      it 'returns nil for nonsense search term on found in' do
        search_term = 'Alice'
        people = Person.search(search_term)
        person = people[0]
        person = Person.includes(:department, :roles, :projects, :activities,
                                 :educations, :advanced_trainings, :expertise_topics)
                       .find(person.id)
        expect(person.found_in('ahdkifekjsdfsakdh34ukjnfv')).to eq(nil)
      end
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
