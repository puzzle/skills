require 'rails_helper'

describe Person::ActivitiesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all activities' do
      keys = %w(id description updated_by role year_from)

      process :index, method: :get, params: { person_id: bob.id }

      activities = json['activities']
      
      expect(activities.count).to eq(1)
      expect(activities.first.count).to eq(6)
      json_object_includes_keys(activities.first, keys)
    end
  end

  describe 'GET show' do
    it 'returns activity' do
      activity = activities(:swisscom)

      process :show, method: :get, params: { person_id: bob.id, id: activity.id }

      activity_json = json['activity']

      expect(activity_json['description']).to eq(activity.description)
    end
  end

  describe 'POST create' do
    it 'creates new activity' do
      activity = { description: 'test description',
                   updated_by: 'Bob',
                   year_from: 2000,
                   year_to: 2015,
                   role: 'test role' }

      post :create, params: { person_id: bob.id, activity: activity }

      new_activity = Activity.find_by(description: 'test description')
      expect(new_activity).not_to eq(nil)
      expect(new_activity.year_from).to eq(2000)
      expect(new_activity.year_to).to eq(2015)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      activity = activities(:swisscom)

      process :update, method: :put, params: { id: activity,
                                               person_id: bob.id,
                                               activity: { description: 'changed' } }

      activity.reload
      expect(activity.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      activity = activities(:swisscom)
      process :destroy, method: :delete, params: { person_id: bob.id, id: activity.id }

      expect(Activity.exists?(activity.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end
end
