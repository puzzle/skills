require 'rails_helper'

describe Person::AdvancedTrainingsController do
  describe 'GET index' do
    it 'returns all advanced_trainings' do
      keys = %w(id description updated_by year_from year_to)

      process :index, method: :get, params: { person_id: bob.id }

      advanced_trainings = json['advanced_trainings']

      expect(advanced_trainings.count).to eq(1)
      expect(advanced_trainings.first.count).to eq(5)
      json_object_includes_keys(advanced_trainings.first, keys)
    end
  end

  describe 'GET show' do
    it 'returns advanced training' do
      course = advanced_trainings(:course)

      process :show, method: :get, params: { person_id: bob.id, id: course.id }

      course_json = json['advanced_training']

      expect(course_json['description']).to eq(course.description)
    end
  end

  describe 'POST create' do
    it 'creates new advanced training' do
      advanced_training = { description: 'test description',
                            updated_by: 'Bob',
                            year_from: 2000,
                            year_to: 2015 }

      post :create, params: { person_id: bob.id, advanced_training: advanced_training }

      new_at = AdvancedTraining.find_by(description: 'test description')
      expect(new_at).not_to eq(nil)
      expect(new_at.year_from).to eq(2000)
      expect(new_at.year_to).to eq(2015)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      course = advanced_trainings(:course)

      process :update, method: :put, params: { id: course, person_id: bob.id, advanced_training: { description: 'changed' } }

      course.reload
      expect(course.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      course = advanced_trainings(:course)
      process :destroy, method: :delete, params: { person_id: bob.id, id: course.id }

      expect(AdvancedTraining.exists?(course.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end
end
