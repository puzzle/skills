require 'rails_helper'

describe Api::PersonRolesController do

  describe 'GET index' do
    it 'returns all person_roles' do
      keys = %w(percent level)
      relationships = %w(person role)

      process :index, method: :get, params: { person_id: bob.id }

      person_roles = json['data']

      expect(person_roles.count).to eq(12)
      expect(person_roles.first['attributes'].count).to eq(2)
      json_object_includes_keys(person_roles.first['attributes'], keys)
      json_object_includes_keys(person_roles.first['relationships'], relationships)
    end
  end

  describe 'GET show' do
    it 'returns people role' do
      person_role = person_roles('bob_software_engineer')

      process :show, method: :get, params: { person_id: bob.id, id: person_role.id }

      person_role_attrs = json['data']['attributes']
      person_role_relat = json['data']['relationships']
      
      expect(person_role_attrs['percent'].to_i).to eq(person_role.percent.to_i)
      expect(person_role_relat['person']['data']['id'].to_i).to eq(person_role.person.id)
      expect(person_role_relat['role']['data']['id'].to_i).to eq(person_role.role.id)
    end
  end

  describe 'POST create' do
    it 'creates new people role' do
      person_role = { percent: 92  }

      post :create, params: create_params(person_role, bob.id, role.id, s1.id)

      new_pr = PersonRole.find_by(percent: '92')
      expect(new_pr).not_to eq(nil)
      expect(new_pr.percent.to_i).to eq(92)
      expect(new_pr.role_id).to eq(role.id)
      expect(new_pr.person_id).to eq(bob.id)
      expect(new_pr.person_role_level.level).to eq('S1')

    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      person_role = person_roles('bob_software_engineer')
      updated_attributes = {percent: 50}

      process :update, method: :put, params: update_params(person_role.id,
                                                           updated_attributes,
                                                           bob.id,
                                                           role.id,
                                                           s2.id)

      person_role.reload
      expect(person_role.percent).to eq(50)
      expect(person_role.person_role_level.level).to eq('S2')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      person_role = person_roles('bob_software_engineer')

      process :destroy, method: :delete, params: {
         person_id: bob.id, id: person_role.id
      }

      expect(PersonRole.exists?(person_role.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end

  def role
    @role ||= roles('software-engineer')
  end

  def s1
    @s1 ||= person_role_levels(:S1)
  end

  def s2
    @s2 ||= person_role_levels(:S2)
  end

  def create_params(object, person_id, role_id, person_role_level_id)
    { data: {attributes:object,
              relationships: {
                person_role_level:{data:{id:person_role_level_id,type:'person_role_levels'}},
                person:{data:{id:person_id,type:'people'}},
                role:{data:{id:role_id,type:'role'}}
              }
            }
    }
  end

  def update_params(object_id, updated_attributes, person_id, role_id, person_role_level_id)
    { data: {
      id: object_id,
      attributes:updated_attributes,
      relationships: {
        person_role_level:{data:{id:person_role_level_id,type:'person_role_levels'}},
        person:{data:{id:person_id,type:'people'}},
        role:{data:{id:role_id,type:'role'}}
      }
    }, id: object_id
}
  end
end
