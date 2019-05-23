require 'rails_helper'

describe ExpertiseTopicSkillValuesController do

  describe 'GET index' do
    it 'returns all expertise_topic_skill_value_skill_values for given params' do
      keys = %w(years_of_experience number_of_projects last_use skill_level comment)

      process :index, method: :get, params: { person_id: people(:bob).id, category_id: expertise_categories(:ruby).id}

      categories = json['data']

      expect(categories.count).to eq(1)
      expect(categories.first['attributes'].count).to eq(5)
      json_object_includes_keys(categories.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns expertise_topic_skill_value' do
      expertise_topic_skill_value = expertise_topic_skill_values(:rails_bob)

      process :show, method: :get, params: { id: expertise_topic_skill_value.id }

      expertise_topic_skill_value_attrs = json['data']['attributes']

      expect(expertise_topic_skill_value_attrs['comment']).to eq(expertise_topic_skill_value.comment)
    end
  end

  describe 'POST create' do
    it 'creates new expertise_topic_skill_value' do
      ExpertiseTopicSkillValue.find_by(person_id: people(:bob),
                                       expertise_topic_id: expertise_topics(:rails)).delete

      expertise_topic_skill_value = { years_of_experience: 1,
                                      number_of_projects: 12,
                                      last_use: 2000,
                                      skill_level: 'expert',
                                      comment: 'very high level' }

      post :create, params: create_params(expertise_topic_skill_value,
                                          expertise_topics(:rails),
                                          people(:bob))

      new_expertise_topic_skill_value = ExpertiseTopicSkillValue.find_by(last_use: 2000)
      expect(new_expertise_topic_skill_value.number_of_projects).to eq(12)
    end
  end

  describe 'PUT update' do
    it 'updates existing expertise_topic_skill_value' do
      expertise_topic_skill_value = expertise_topic_skill_values(:rails_bob)
      updated_attributes = { comment: 'changed', skill_level: 'expert' }

      process :update, method: :put, params: update_params(expertise_topic_skill_value.id, updated_attributes)

      expertise_topic_skill_value.reload
      expect(expertise_topic_skill_value.comment).to eq('changed') ##
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing expertise_topic_skill_value' do
      expertise_topic_skill_value = expertise_topic_skill_values(:rails_bob)
      process :destroy, method: :delete, params: { id: expertise_topic_skill_value.id }

      expect(ExpertiseTopicSkillValue.exists?(expertise_topic_skill_value.id)).to be false
    end
  end

  private

  def create_params(object, parent_id, person_id)
    { data: { attributes: object,
              relationships: {
                expertise_topic: { data: { id: parent_id } },
                person: { data: { id: person_id } }
              }
            } }
  end

  def update_params(object_id, updated_attributes)
    { data: { id: object_id,
              attributes: updated_attributes},
      id: object_id }
  end

end
