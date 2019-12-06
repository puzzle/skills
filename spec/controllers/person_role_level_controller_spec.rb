require 'rails_helper'

describe PersonRoleLevelController do
  describe 'GET index' do
    it 'returns all person_role_levels' do
      get :index

      person_role_levels = json['data']
    
      expect(person_role_levels.count).to eq(4)
      expect(person_role_levels.first['attributes']['level']).to eq('S1')
      expect(person_role_levels.second['attributes']['level']).to eq('S2')
    end
  end

  describe 'GET show' do
    it 'returns S1 person_role_level' do
       get :show, params:{ id: s1.id }

       person_role_levels = json['data']['attributes']

      expect(person_role_levels['level']).to eq('S1')
    end
  end

  describe 'POST create person_role_level' do
    it 'creates person_role_level' do
        person_role_level = {data:{type:"person_role_levels",attributes:{level:"S5"}}}

       process :create, method: :post, params: person_role_level

       new_p_r_l = PersonRoleLevel.find_by(level: 'S5')
       expect(new_p_r_l).not_to eq(nil)
       expect(new_p_r_l.level).to eq('S5')
    end
  end

  private

  def s1
    @s1 ||= person_role_levels(:S1)
  end
end
