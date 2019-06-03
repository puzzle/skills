require 'rails_helper'

describe People::SkillsController do
  describe 'PeopleSkillsController' do
    before { load_pictures }

    let(:ken) { users(:ken) }

    describe 'GET index' do
      it 'returns kens skills' do
        keys = %w[person_id skill_id level interest certificate core_competence]

        process :index, method: :get, params: { type: 'Person', person_id: ken.id }

        skills = json['data']

        expect(skills.count).to eq(2)
        junit_attrs = skills.first['attributes']
        expect(junit_attrs.count).to eq (6)
        expect(junit_attrs['person_id']).to eq (ken.id)
        json_object_includes_keys(junit_attrs, keys)
      end
    end
  end
end
