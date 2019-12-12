require 'rails_helper'

describe PersonRoleLevelsController do
  describe 'GET index' do
    it 'returns all person_role_levels' do
      get :index

      person_role_levels = json['data']

      expect(person_role_levels.count).to eq(4)
      expect(person_role_levels.first['attributes']['level']).to eq('S1')
      expect(person_role_levels.second['attributes']['level']).to eq('S2')
    end
  end

  private

  def s1
    @s1 ||= person_role_levels(:S1)
  end
end
