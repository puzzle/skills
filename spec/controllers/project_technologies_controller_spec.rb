require 'rails_helper'

describe ProjectTechnologiesController do

  describe 'GET index' do
    it 'returns all project_technology' do
      keys = %w(offer)

      process :index, method: :get, params: { type: 'Project', project_id: project.id }

      project_technologies = json['data']

      expect(project_technologies.count).to eq(1)
      expect(project_technologies.first['attributes'].count).to eq(1)
      json_object_includes_keys(project_technologies.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns project_technologies' do
      project_technology = project_technologies(:duckduckgo_technologies)

      process :show, method: :get, params: { type: 'Project', project_id: project.id, id: project_technology.id }

      project_technology_attrs = json['data']['attributes']

      expect(project_technology_attrs['offer']).to eq(project_technology.offer)
    end
  end

  describe 'POST create' do
    it 'creates new project_technology' do
      project_technology = { offer: ['Mongo DB', 'PostgreSQL']}

      post :create, params: create_params(project_technology, project.id, 'project_technology')

      new_project_technology = ProjectTechnology.find_by(offer: ['Mongo DB', 'PostgreSQL'])
      expect(new_project_technology).not_to eq(nil)
      expect(new_project_technology.offer).to eq(['Mongo DB', 'PostgreSQL'])
    end
  end

  describe 'PUT update' do
    it 'updates existing project_technology' do
      project_technology = project_technologies(:duckduckgo_technologies)
      updated_attributes = { offer: ['Mongo DB', 'PostgreSQL'] }

      process :update, method: :put, params: update_params(project_technology.id,
                                                           updated_attributes,
                                                           project.id, 'project_technology')
      project_technology.reload
      expect(project_technology.offer).to eq(['Mongo DB', 'PostgreSQL'])
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing project_technology' do
      project_technology = project_technologies(:duckduckgo_technologies)
      process :destroy, method: :delete, params: {
        type: 'Project', project_id: project.id, id: project_technology.id
      }

      expect(ProjectTechnology.exists?(project_technology.id)).to eq(false)
    end
  end

  private

  def project
    @project ||= projects(:duckduckgo)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object,
              relationships: { project: { data: { type: 'Projects',
                                                 id: user_id } } }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id,
              attributes: updated_attributes,
              relationships: {
                project: { data: { type: 'Projects', id: user_id } }
              }, type: model_type }, id: object_id }
  end
end
