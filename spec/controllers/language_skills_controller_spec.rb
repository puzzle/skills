require 'rails_helper'
describe LanguageSkillsController, type: :controller do

  describe 'GET show' do
    it 'returns language_skill' do
      language_skill = language_skills(:deutsch)

      process :show, method: :get, params: { person_id: bob.id, id: language_skill.id }

      language_skill_attrs = json['data']['attributes']

      expect(language_skill_attrs['language']).to eq(language_skill.language)
    end
  end

  describe 'POST create' do
    it 'creates new language_skill' do
      language_skill = { language: 'FR',
                         level: 'C2',
                         certificate: 'Brighthurst TAFE' }

      post :create, params: create_params(language_skill, bob.id, 'language_skills')

      new_language_skill = LanguageSkill.find_by(language: 'FR')
      expect(new_language_skill).not_to eq(nil)
      expect(new_language_skill.language).to eq('FR')
      expect(new_language_skill.level).to eq('C2')
      expect(new_language_skill.certificate).to eq('Brighthurst TAFE')
    end
  end

  describe 'PUT update' do
    it 'updates existing language_skill' do
      language_skill = language_skills(:deutsch)
      updated_attributes = { certificate: 'changed' }
      process :update, method: :put, params: update_params(language_skill.id,
                                                           updated_attributes,
                                                           bob.id,
                                                           'language_skills')

      language_skill.reload
      expect(language_skill.certificate).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing language_skill' do
      language_skill = language_skills(:spanisch)
      process :destroy, method: :delete, params: { person_id: bob.id,
                                                   id: language_skill.id }

      expect(LanguageSkill.exists?(language_skill.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object, relationships: {
      person: { data: { type: 'People',
                        id: user_id } }
    }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                person: { data: { type: 'people',
                                  id: user_id } }
              }, type: model_type }, id: object_id }
  end
end
