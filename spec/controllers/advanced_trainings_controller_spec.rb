require 'rails_helper'

describe AdvancedTrainingsController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all advanced_trainings' do
      keys = %w(description updated_by year_from year_to)

      process :index, method: :get, params: { type: 'Person', person_id: bob.id }

      advanced_trainings = json['data']

      expect(advanced_trainings.count).to eq(1)
      expect(advanced_trainings.first['attributes'].count).to eq(4)
      json_object_includes_keys(advanced_trainings.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns advanced training' do
      course = advanced_trainings(:course)

      process :show, method: :get, params: { type: 'Person', person_id: bob.id, id: course.id }

      course_attrs = json['data']['attributes']

      expect(course_attrs['description']).to eq(course.description)
    end
  end

  describe 'POST create' do
    it 'creates new advanced training' do
      advanced_training = { description: 'test description',
                            updated_by: 'Bob',
                            year_from: 2000,
                            year_to: 2015 }

      post :create, params: create_params(advanced_training, bob.id, 'advanced-training') 

      new_at = AdvancedTraining.find_by(description: 'test description')
      expect(new_at).not_to eq(nil)
      expect(new_at.year_from).to eq(2000)
      expect(new_at.year_to).to eq(2015)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      course = advanced_trainings(:course)
      updated_attributes = {description: 'changed'}
      process :update, method: :put, params: update_params(course.id, updated_attributes, bob.id, 'advanced-training')

      course.reload
      expect(course.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      course = advanced_trainings(:course)
      process :destroy, method: :delete, params: {
        type: 'Person', person_id: bob.id, id: course.id
      }

      expect(AdvancedTraining.exists?(course.id)).to eq(false)
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
