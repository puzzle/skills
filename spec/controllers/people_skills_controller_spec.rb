require 'rails_helper'

describe PeopleSkillsController do
  describe 'PeopleSkillsController' do
    before { auth(:ken) }
    before { load_pictures }

    let(:bob) { people(:bob) }
    let(:rails) { skills(:rails) }

    describe 'GET index' do
      it 'returns bobs people_skills' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Person', person_id: bob.id }

        skills = json['data']

        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs.count).to eq (6)
        expect(rails_attrs['person_id']).to eq (bob.id)
        json_object_includes_keys(rails_attrs, keys)
      end

      it 'returns Rails skills' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id }

        skills = json['data']

        expect(skills.count).to eq(2)
        skill_attrs = skills.first['attributes']
        expect(skill_attrs.count).to eq (6)
        expect(skill_attrs['skill_id']).to eq (rails.id)
        json_object_includes_keys(skill_attrs, keys)
      end
    end
  end
end
