require 'rails_helper'

describe ExpertiseTopicsController do

  describe 'GET index' do
    it 'returns all expertise_topics for given category' do
      keys = %w(name user_topic)

      process :index, method: :get, params: { category_id: expertise_categories(:ruby).id }

      categories = json['data']

      expect(categories.count).to eq(1)
      expect(categories.first['attributes'].count).to eq(2)
      json_object_includes_keys(categories.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns expertise_topic' do
      expertise_topic = expertise_topics(:rails)

      process :show, method: :get, params: { id: expertise_topic.id }

      expertise_topic_attrs = json['data']['attributes']

      expect(expertise_topic_attrs['name']).to eq(expertise_topic.name)
    end
  end

  describe 'POST create' do
    it 'creates new expertise_topic' do
      expertise_topic = { name: 'new_topic',
                          user_topic: 'true' }

      post :create, params: create_params(expertise_topic, expertise_categories(:ruby))

      new_expertise_topic = ExpertiseTopic.find_by(name: 'new_topic')
      expect(new_expertise_topic).not_to eq(nil)
    end
  end

  describe 'PUT update' do
    it 'updates existing expertise_topic' do
      expertise_topic = expertise_topics(:rails)
      updated_attributes = { name: 'changed' }

      process :update, method: :put, params: update_params(expertise_topic.id, updated_attributes)

      expertise_topic.reload
      expect(expertise_topic.name).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing expertise_topic' do
      expertise_topic = expertise_topics(:rails)
      process :destroy, method: :delete, params: { id: expertise_topic.id }

      expect(ExpertiseTopic.exists?(expertise_topic.id)).to be false
    end
  end

  private

  def create_params(object, parent_id)
    { data: { attributes: object,
              relationships: { expertise_category: { data: { id: parent_id } } }
            } }
  end

  def update_params(object_id, updated_attributes)
    { data: { id: object_id,
              attributes: updated_attributes},
      id: object_id }
  end
end
