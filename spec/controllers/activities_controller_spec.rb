require 'rails_helper'

describe ActivitiesController do
  
  describe 'GET index' do
    it 'returns all activities' do
      keys = %w(description updated_by role year_to)

      process :index, method: :get, params: { person_id: bob.id }

      activities = json['data']

      expect(activities.count).to eq(1)
      expect(activities.first['attributes'].count).to eq(7)
      json_object_includes_keys(activities.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns activity' do
      activity = activities(:swisscom)

      process :show, method: :get, params: { person_id: bob.id, id: activity.id }

      activity_attrs = json['data']['attributes']

      expect(activity_attrs['description']).to eq(activity.description)
    end
  end

  describe 'POST create' do
    it 'creates new activity' do
      activity = { description: 'test description',
                   updated_by: 'Bob',
                   year_to: 2013,
                   month_to: 3,
                   year_from: 2010,
                   month_from: 10,
                   role: 'test role' }

      post :create, params: create_params(activity, bob.id, 'activity')

      new_activity = Activity.find_by(description: 'test description')
      expect(new_activity).not_to eq(nil)
      expect(new_activity.year_to).to eq(2013)
      expect(new_activity.month_to).to eq(3)
      expect(new_activity.year_from).to eq(2010)
      expect(new_activity.month_from).to eq(10)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      activity = activities(:swisscom)
      updated_attributes = { description: 'changed' }

      process :update, method: :put, params: update_params(activity.id,
                                                           updated_attributes,
                                                           bob.id, 'activity')
      activity.reload
      expect(activity.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      activity = activities(:swisscom)
      process :destroy, method: :delete, params: {
        person_id: bob.id, id: activity.id
      }

      expect(Activity.exists?(activity.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object,
              relationships: { person: { data: { id: user_id } } }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                person: { data: { id: user_id } }
              }, type: model_type }, id: object_id }
  end
end
