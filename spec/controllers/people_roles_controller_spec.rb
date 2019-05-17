require 'rails_helper'

describe PeopleRolesController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all people_roles' do
      keys = %w(level percent role_id person_id)
      relationships = %w(person role)

      process :index, method: :get, params: { person_id: bob.id }

      people_roles = json['data']

      expect(people_roles.count).to eq(5)
      expect(people_roles.first['attributes'].count).to eq(4)
      json_object_includes_keys(people_roles.first['attributes'], keys)
      json_object_includes_keys(people_roles.first['relationships'], relationships)
    end
  end

  describe 'GET show' do
    it 'returns people role' do
      people_role = people_roles('bob_software_engineer')

      process :show, method: :get, params: { person_id: bob.id, id: people_role.id }

      people_role_attrs = json['data']['attributes']

      expect(people_role_attrs['level']).to eq(people_role.level)
      expect(people_role_attrs['percent'].to_i).to eq(people_role.percent.to_i)
    end
  end

  describe 'POST create' do
    it 'creates new people role' do
      people_role = { level: 'S42',
                      percent: 100  }

      post :create, params: create_params(people_role, bob.id, role.id)

      new_pr = PeopleRole.find_by(level: 'S42')
      expect(new_pr).not_to eq(nil)
      expect(new_pr.percent.to_i).to eq(100)
      expect(new_pr.role_id).to eq(role.id)
      expect(new_pr.person_id).to eq(bob.id)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      people_role = people_roles('bob_software_engineer')
      updated_attributes = { percent: 50,
                             level: 'S9000' }

      process :update, method: :put, params: update_params(people_role.id,
                                                           updated_attributes,
                                                           bob.id,
                                                           role.id)

      people_role.reload
      expect(people_role.percent).to eq(50)
      expect(people_role.level).to eq('S9000')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      people_role = people_roles('bob_software_engineer')

      process :destroy, method: :delete, params: {
         person_id: bob.id, id: people_role.id
      }

      expect(PeopleRole.exists?(people_role.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end
  
  def role
    @role ||= roles('software-engineer')
  end

  def create_params(object, person_id, role_id)
    { data: { attributes: object,
              relationships: {
                person: { data: { type: 'people', id: person_id } },
                role: { data: { type: 'people', id: role_id } }
              }, type: 'people-roles' } }
  end

  def update_params(object_id, updated_attributes, person_id, role_id)
    { data: {
      id: object_id,
      attributes: updated_attributes,
      relationships: {
        person: { data: { type: 'people', id: person_id } },
        role: { data: { type: 'people', id: role_id } }
      }, type: 'people-roles'
    }, id: object_id }
  end
end
