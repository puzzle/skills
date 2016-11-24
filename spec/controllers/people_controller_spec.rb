require 'rails_helper'

describe PeopleController do
  describe 'GET index' do
    it 'returns all people without nested models' do
      keys =  %w(id birthdate profile_picture language location martial_status
                 updated_by name origin role title status)

      process :index, method: :get

      people = json['people']

      expect(people.count).to eq(2)
      expect(people.first.count).to eq(12)
      json_object_includes_keys(people.first, keys)
    end
  end

  describe 'GET show' do
    it 'returns person with nested modules' do
      keys =  %w(id birthdate profile_picture language location martial_status updated_by name origin
                 role title status advanced_trainings activities projects educations competences)

      bob = people(:bob)

      process :show, method: :get, params: { id: bob.id}

      bob_json = json['person']

      expect(bob_json.count).to eq(17)
      json_object_includes_keys(bob_json, keys)
    end
  end

  describe 'POST create' do
    it 'creates new person' do
      person = { birthdate: Time.now,
                 profile_picture: 'test',
                 language: 'German',
                 location: 'Bern',
                 martial_status: 'single',
                 name: 'test',
                 origin: 'Switzerland',
                 role: 'tester',
                 title: 'Bsc in tester',
                 status_id: 2 }

      process :create, method: :post, params: { person: person}

      new_person = Person.find_by(name: 'test')
      expect(new_person).not_to eq(nil)
      expect(new_person.location).to eq('Bern')
      expect(new_person.language).to eq('German')
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      bob = people(:bob)

      process :update, method: :put, params: { id: bob.id, person: { location: 'test_location' } }

      bob.reload
      expect(bob.location).to eq('test_location')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      bob = people(:bob)
      process :destroy, method: :delete, params: {id: bob.id }

      expect(Person.exists?(bob.id)).to eq(false)
      expect(Activity.exists?(person_id: bob.id)).to eq(false)
      expect(AdvancedTraining.exists?(person_id: bob.id)).to eq(false)
      expect(Project.exists?(person_id: bob.id)).to eq(false)
      expect(Education.exists?(person_id: bob.id)).to eq(false)
      expect(Competence.exists?(person_id: bob.id)).to eq(false)
    end
  end
end
