require 'rails_helper'

describe Api::PeopleSkillsController do
  describe 'PeopleSkillsController' do
    before { load_pictures }

    let(:bob) { people(:bob) }
    let(:bob_rails) { people_skills(:bob_rails) }
    let(:wally_rails) { people_skills(:wally_rails) }
    let(:charlie_rails) { people_skills(:charlie_rails) }
    let(:hope_rails) { people_skills(:hope_rails) }
    let(:wally_cunit) { people_skills(:wally_cunit) }
    let(:charlie_cunit) { people_skills(:charlie_cunit) }
    let(:wally_ember) { people_skills(:wally_ember) }
    let(:wally_junit) { people_skills(:wally_junit) }
    let(:wally_bash) { people_skills(:wally_bash) }
    let(:rails) { skills(:rails) }
    let(:cunit) { skills(:cunit) }
    let(:ember) { skills(:ember) }
    let(:bash) { skills(:bash) }
    let(:junit) { skills(:junit) }

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
        keys = %w[person skills]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '1', interest: '1'}

        skills = json['data']
        expect(skills.count).to eq(4)
        skill_relationships_bob = skills.first['relationships']
        skill_relationships_charlie = skills.second['relationships']
        skill_relationships_wally = skills.third['relationships']
        skill_relationships_hope = skills.fourth['relationships']
        expect(skill_relationships_bob.count).to eq (2)
        expect(skill_relationships_charlie.count).to eq (2)
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_hope.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].count).to eq (1)
        expect(skill_relationships_hope['skills']['data'].count).to eq (1)
        expect(skill_relationships_charlie['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].first['id']).to eq (bob_rails.id.to_s)
        expect(skill_relationships_charlie['skills']['data'].first['id']).to eq (charlie_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        expect(skill_relationships_hope['skills']['data'].first['id']).to eq (hope_rails.id.to_s)
        json_object_includes_keys(skill_relationships_bob, keys)
        json_object_includes_keys(skill_relationships_charlie, keys)
        json_object_includes_keys(skill_relationships_wally, keys)
        json_object_includes_keys(skill_relationships_hope, keys)
      end

      it 'only returns above a level' do
        keys = %w[person skills]

        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '2', interest: '1'}

        skills = json['data']
        expect(skills.count).to eq(2)
        skill_relationships_bob = skills.first['relationships']
        skill_relationships_wally = skills.second['relationships']
        expect(skill_relationships_bob.count).to eq (2)
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].first['id']).to eq (bob_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        json_object_includes_keys(skill_relationships_bob, keys)
        json_object_includes_keys(skill_relationships_wally, keys)
      end

      it 'only returns above an interest' do
        keys = %w[person skills]
      
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '1', interest: '4'}

        skills = json['data']
        expect(skills.count).to eq(3)
        skill_relationships_bob = skills.first['relationships']
        skill_relationships_wally = skills.second['relationships']
        skill_relationships_hope = skills.third['relationships']
        expect(skill_relationships_bob.count).to eq (2)
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_hope.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].count).to eq (1)
        expect(skill_relationships_hope['skills']['data'].count).to eq (1)
        expect(skill_relationships_bob['skills']['data'].first['id']).to eq (bob_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        expect(skill_relationships_hope['skills']['data'].first['id']).to eq (hope_rails.id.to_s)
        json_object_includes_keys(skill_relationships_bob, keys)
        json_object_includes_keys(skill_relationships_wally, keys)
        json_object_includes_keys(skill_relationships_hope, keys)
      end

      it 'returns no skills' do
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id, level: '5', interest: '5'}

        skills = json['data']
        expect(skills.count).to eq(0)
      end

      it 'returns AND search' do
        keys = %w[person skills]

        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + cunit.id.to_s, level: '1,4', interest: '1,1'}

        skills = json['data']
        expect(skills.count).to eq(2)
        skill_relationships_charlie = skills.first['relationships']
        skill_relationships_wally = skills.second['relationships']
        expect(skill_relationships_charlie.count).to eq (2)
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (2)
        expect(skill_relationships_charlie['skills']['data'].count).to eq (2)
        expect(skill_relationships_charlie['skills']['data'].first['id']).to eq (charlie_rails.id.to_s)
        expect(skill_relationships_charlie['skills']['data'].second['id']).to eq (charlie_cunit.id.to_s)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].second['id']).to eq (wally_cunit.id.to_s)
        json_object_includes_keys(skill_relationships_charlie, keys)
        json_object_includes_keys(skill_relationships_wally, keys)
      end

      it 'returns AND search for 4' do
        keys = %w[person skills]

        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + junit.id.to_s + "," + ember.id.to_s + "," + cunit.id.to_s, level: '1,4,1,1', interest: '1,1,1,1'}

        skills = json['data']
        expect(skills.count).to eq(1)
        skill_relationships_wally = skills.first['relationships']
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (4)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].second['id']).to eq (wally_junit.id.to_s)
        expect(skill_relationships_wally['skills']['data'].third['id']).to eq (wally_cunit.id.to_s)
        expect(skill_relationships_wally['skills']['data'].fourth['id']).to eq (wally_ember.id.to_s)
        json_object_includes_keys(skill_relationships_wally, keys)
      end

      it 'does not return if one level is too high' do
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + junit.id.to_s + "," + ember.id.to_s + "," + cunit.id.to_s, level: '1,1,6,1', interest: '1,1,1,1'}

        skills = json['data']
        expect(skills.count).to eq(0)
      end

      it 'does not return if one interest is too high' do
        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + junit.id.to_s + "," + ember.id.to_s + "," + cunit.id.to_s, level: '1,1,1,1', interest: '1,6,1,1'}

        skills = json['data']
        expect(skills.count).to eq(0)
      end

      it 'returns AND search for 5' do
        keys = %w[person skills]

        process :index, method: :get, params: { type: 'Skill', skill_id: rails.id.to_s + "," + junit.id.to_s + "," + bash.id.to_s + "," + ember.id.to_s + "," + cunit.id.to_s, level: '1,1,1,1,1', interest: '1,1,1,1,1'}

        skills = json['data']
        expect(skills.count).to eq(1)
        skill_relationships_wally = skills.first['relationships']
        expect(skill_relationships_wally.count).to eq (2)
        expect(skill_relationships_wally['skills']['data'].count).to eq (5)
        expect(skill_relationships_wally['skills']['data'].first['id']).to eq (wally_rails.id.to_s)
        expect(skill_relationships_wally['skills']['data'].second['id']).to eq (wally_junit.id.to_s)
        expect(skill_relationships_wally['skills']['data'].third['id']).to eq (wally_bash.id.to_s)
        expect(skill_relationships_wally['skills']['data'].fourth['id']).to eq (wally_cunit.id.to_s)
        expect(skill_relationships_wally['skills']['data'].fifth['id']).to eq (wally_ember.id.to_s)
        json_object_includes_keys(skill_relationships_wally, keys)
      end
    end
  end
end
