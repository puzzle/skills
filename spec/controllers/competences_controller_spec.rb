require 'rails_helper'

describe CompetencesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all competences' do
      keys = %w(description updated_by)
      process :index, method: :get, params: { type: 'Person', person_id: bob.id }

      competences = json['data']

      expect(competences.count).to eq(1)
      expect(competences.first['attributes'].count).to eq(2)
      json_object_includes_keys(competences.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns competence' do
      competence = competences(:scrum)

      process :show, method: :get, params: { type: 'Person', person_id: bob.id, id: competence.id }

      competence_attrs = json['data']['attributes']

      expect(competence_attrs['description']).to eq(competence.description)
    end
  end

  describe 'POST create' do
    it 'creates new competence' do
      competence = { description: 'test description',
                     updated_by: 'Bob' }

      post :create, params: create_params(competence, bob.id, 'competences') 

      new_competence = Competence.find_by(description: 'test description')
      expect(new_competence).not_to eq(nil)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      competence = competences(:scrum)
      updated_attributes = {description: 'changed'}
      process :update, method: :put, params: update_params(competence.id, updated_attributes, bob.id, 'competences')
      competence.reload
      expect(competence.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      competence = competences(:scrum)
      process :destroy, method: :delete, params: {
        type: 'Person', person_id: bob.id, id: competence.id
      }

      expect(Competence.exists?(competence.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end

  def create_params(object, user_id, model_type)
    {data: { attributes: object, relationships: { person: {data: { type: 'People', id: user_id}}}, type: model_type}}
  end

  def update_params(objectId, updated_attributes, user_id, model_type)
    {data: {id: objectId, attributes: updated_attributes, relationships: { person: {data: { type: 'people', id: user_id}}}, type: model_type}, id: objectId}
  end
end
