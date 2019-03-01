require 'rails_helper'

describe SkillsController do
  describe 'SkillsController' do
    before { auth(:ken) }
    before { load_pictures }

    describe 'GET index' do
      it 'returns all skills with nested models' do
        keys = %w[title radar portfolio default_set]
        get :index

        skills = json['data']

        expect(skills.count).to eq(2)
        junit_attrs = skills.first['attributes']
        expect(junit_attrs.count).to eq (5)
        expect(junit_attrs['title']).to eq ('JUnit')
        json_object_includes_keys(junit_attrs, keys)

      end
    end
  end
end
