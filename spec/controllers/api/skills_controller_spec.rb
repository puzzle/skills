require 'rails_helper'

describe Api::SkillsController do
  describe 'SkillsController as admin' do
    before { load_pictures }

    before(:each) do
      allow_any_instance_of(SkillsController).to receive(:admin_flag?).and_return(true)
    end

    let(:bob) { people(:bob) }

    describe 'GET index' do
      it 'returns all skills with nested models' do
        keys = %w[title radar portfolio default_set]
        get :index

        skills = json['data']
        expect(skills.count).to eq(5)
        bash_attrs = skills.first['attributes']
        expect(bash_attrs.count).to eq (5)
        expect(bash_attrs['title']).to eq ('Bash')
        json_object_includes_keys(bash_attrs, keys)
      end

      it 'returns skills where title contains a' do
        get :index, params: { title: 'a' }

        skills = json['data']
        expect(skills.count).to eq(2)
        first_skill_attrs = skills.first['attributes']
        expect(first_skill_attrs['title']).to eq ('Bash')
        second_skill_attrs = skills.second['attributes']
        expect(second_skill_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with default_set true' do
        get :index, params: { defaultSet: 'true' }

        skills = json['data']
        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with default_set new' do
        get :index, params: { defaultSet: 'new' }

        skills = json['data']
        expect(skills.count).to eq(1)
        bash_attrs = skills.first['attributes']
        expect(bash_attrs['title']).to eq ('Bash')
      end

      it 'returns skills with parent category software-engineering' do
        parent_category = categories(:'software-engineering')
        get :index, params: { category: parent_category.id }

        skills = json['data']
        expect(skills.count).to eq(3)
        cunit_attrs = skills.first['attributes']
        junit_attrs = skills.second['attributes']
        rails_attrs = skills.third['attributes']
        expect(cunit_attrs['title']).to eq ('cunit')
        expect(junit_attrs['title']).to eq ('JUnit')
        expect(rails_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with parent category software-engineering and defaultSet true' do
        parent_category = categories(:'software-engineering')
        get :index, params: { category: parent_category.id, defaultSet: 'true' }

        skills = json['data']
        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs['title']).to eq ('Rails')
      end
    end

    describe 'GET unrated_for_person' do
      it 'returns all unrated PeopleSkills of bob' do
        process :unrated_by_person, params: { type: 'Person', person_id: bob.id }

        skills = json['data']

        expect(skills).to be_empty
      end

      it 'returns all unrated PeopleSkills of ken' do
        process :unrated_by_person, params: { type: 'Person', person_id: people(:ken).id }

        skills = json['data']
        unrated_skill_attrs = skills.first['attributes']

        expect(unrated_skill_attrs['title']).to eq ('Rails')
      end

      it 'returns all skills if no person_id is given' do
        process :unrated_by_person

        skills = json['data']

        expect(skills.count).to eq(5)
      end
    end
  end
  describe 'SkillsController as normal user' do
    before { load_pictures }

    before(:each) do
      allow_any_instance_of(SkillsController).to receive(:admin_flag?).and_return(false)
    end

    let(:bob) { people(:bob) }

    describe 'GET index' do
      it 'returns all skills with nested models' do
        keys = %w[title radar portfolio default_set]
        get :index

        skills = json['data']
        expect(skills.count).to eq(5)
        bash_attrs = skills.first['attributes']
        expect(bash_attrs.count).to eq (5)
        expect(bash_attrs['title']).to eq ('Bash')
        json_object_includes_keys(bash_attrs, keys)
      end

      it 'returns skills where title contains a' do
        get :index, params: { title: 'a' }

        skills = json['data']
        expect(skills.count).to eq(2)
        first_skill_attrs = skills.first['attributes']
        expect(first_skill_attrs['title']).to eq ('Bash')
        second_skill_attrs = skills.second['attributes']
        expect(second_skill_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with default_set true' do
        get :index, params: { defaultSet: 'true' }

        skills = json['data']
        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with default_set new' do
        get :index, params: { defaultSet: 'new' }

        skills = json['data']
        expect(skills.count).to eq(1)
        bash_attrs = skills.first['attributes']
        expect(bash_attrs['title']).to eq ('Bash')
      end

      it 'returns skills with parent category software-engineering' do
        parent_category = categories(:'software-engineering')
        get :index, params: { category: parent_category.id }

        skills = json['data']
        expect(skills.count).to eq(3)
        cunit_attrs = skills.first['attributes']
        junit_attrs = skills.second['attributes']
        rails_attrs = skills.third['attributes']
        expect(cunit_attrs['title']).to eq ('cunit')
        expect(junit_attrs['title']).to eq ('JUnit')
        expect(rails_attrs['title']).to eq ('Rails')
      end

      it 'returns skills with parent category software-engineering and defaultSet true' do
        parent_category = categories(:'software-engineering')
        get :index, params: { category: parent_category.id, defaultSet: 'true' }

        skills = json['data']
        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs['title']).to eq ('Rails')
      end
    end
    describe 'Can not edit as normal user' do
      it 'raises error when editing as normal user' do
        process :update, method: :put, params: { id: Skill.last.id, data: { skill: {title: "Updated"} } }
        expect(response.status).to eq 401
      end
    end
  end
end
