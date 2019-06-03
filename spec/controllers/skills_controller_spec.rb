require 'rails_helper'

describe SkillsController do
  describe 'SkillsController' do
    before { load_pictures }

    describe 'GET index' do
      it 'returns all skills with nested models' do
        keys = %w[title radar portfolio default_set]
        get :index

        skills = json['data']

        expect(skills.count).to eq(3)
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
        parent_category = category(:'software-engineering')
        get :index, params: { category: parent_category.id }

        skills = json['data']
        expect(skills.count).to eq(2)
        junit_attrs = skills.first['attributes']
        expect(junit_attrs['title']).to eq ('JUnit')
      end

      it 'returns skills with parent category software-engineering and defaultSet true' do
        parent_category = category(:'software-engineering')
        get :index, params: { category: parent_category.id, defaultSet: 'true' }

        skills = json['data']
        expect(skills.count).to eq(1)
        rails_attrs = skills.first['attributes']
        expect(rails_attrs['title']).to eq ('Rails')
      end
    end
  end
end
