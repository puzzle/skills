require 'rails_helper'

describe PeopleSkillsController do
  describe 'PeopleSkillsController' do
    before { load_pictures }

    let(:bob) { people(:bob) }
    let(:lain) { people(:lain) }
    let(:rails) { skills(:rails) }
    let(:cunit) { skills(:cunit) }

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
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '0'}

        skills = json['data']
        expect(skills.count).to eq(3)
        skill_attrs = skills.first['attributes']
        expect(skill_attrs.count).to eq (6)
        expect(skill_attrs['skill_id']).to eq (rails.id)
        json_object_includes_keys(skill_attrs, keys)
      end

      it 'only returns above a level' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '2'}

        skills = json['data']
        expect(skills.count).to eq(1)
        skill_attrs = skills.first['attributes']
        expect(skill_attrs['skill_id']).to eq (rails.id)
        expect(skill_attrs['level']).to eq (3)
      end

      it 'returns level itself' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '3'}

        skills = json['data']
        expect(skills.count).to eq(1)
        skill_attrs = skills.first['attributes']
        expect(skill_attrs['skill_id']).to eq (rails.id)
        expect(skill_attrs['level']).to eq (3)
      end

      it 'returns AND search' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + cunit.id.to_s, level: '1,4'}

        skills = json['data']
        expect(skills.count).to eq(1)
      end

      it 'does not return if one level is too high' do
        keys = %w[person_id skill_id level interest certificate core_competence]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + cunit.id.to_s, level: '4,4'}

        skills = json['data']
        expect(skills.count).to eq(0)
      end
    end
  end
end
