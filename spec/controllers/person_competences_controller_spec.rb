require 'rails_helper'

describe PersonCompetencesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all person_competences' do
      keys = %w(category offer)

      process :index, method: :get, params: { person_id: person.id }

      person_competences = json['data']

      expect(person_competences.count).to eq(1)
      expect(person_competences.first['attributes'].count).to eq(2)
      json_object_includes_keys(person_competences.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns person_competences' do
      person_competence = person_competences(:technologien)

      process :show, method: :get, params: { person_id: person.id, id: person_competence.id }

      person_competence_attrs = json['data']['attributes']

      expect(person_competence_attrs['category']).to eq(person_competence.category)
      expect(person_competence_attrs['offer']).to eq(person_competence.offer)
    end
  end

  describe 'POST create' do
    it 'creates new person_competence' do
      person_competence = { category: 'Datenbanken', offer: ['Mongo DB', 'PostgreSQL']}

      post :create, params: create_params(person_competence, person.id, 'person_competence')

      new_person_competence = PersonCompetence.find_by(category: 'Datenbanken')
      expect(new_person_competence).not_to eq(nil)
      expect(new_person_competence.category).to eq('Datenbanken')
      expect(new_person_competence.offer).to eq(['Mongo DB', 'PostgreSQL'])
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      person_competence = person_competences(:technologien)
      updated_attributes = { category: 'Werkzeuge' }

      process :update, method: :put, params: update_params(person_competence.id,
                                                           updated_attributes,
                                                           person.id, 'person_competence')
      person_competence.reload
      expect(person_competence.category).to eq('Werkzeuge')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person_competence' do
      person_competence = person_competences(:technologien)
      process :destroy, method: :delete, params: {
        person_id: person.id, id: person_competence.id
      }

      expect(PersonCompetence.exists?(person_competence.id)).to eq(false)
    end
  end

  private

  def person
    @person ||= people(:bob)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object,
              relationships: { person: { data: { type: 'People',
                                                 id: user_id } } }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                person: { data: { type: 'People', id: user_id } }
              }, type: model_type }, id: object_id }
  end
end
