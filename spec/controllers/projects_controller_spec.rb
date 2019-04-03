require 'rails_helper'

describe ProjectsController do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all projects' do
      keys = %w(technology title description role updated_by year_from)
      process :index, method: :get, params: { person_id: bob.id }

      projects = json['data']

      expect(projects.count).to eq(1)
      expect(projects.first['attributes'].count).to eq(9)
      json_object_includes_keys(projects.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns project' do
      project = projects(:duckduckgo)

      process :show, method: :get, params: { person_id: bob.id, id: project.id }

      project_attrs = json['data']['attributes']

      expect(project_attrs['technology']).to eq(project.technology)
      expect(project_attrs['title']).to eq(project.title)
      expect(project_attrs['description']).to eq(project.description)
      expect(project_attrs['role']).to eq(project.role)
    end
  end

  describe 'POST create' do
    it 'creates new project' do
      project = { description: 'test description',
                  updated_by: 'Bob',
                  year_to: 2013,
                  month_to: 3,
                  year_from: 2010,
                  month_from: 10,
                  title: 'test title',
                  technology: 'test technology',
                  role: 'test role' }

      post :create, params: create_params(project, bob.id, 'projects')

      new_project = Project.find_by(description: 'test description')
      expect(new_project).not_to eq(nil)
      expect(new_project.year_to).to eq(2013)
      expect(new_project.month_to).to eq(3)
      expect(new_project.year_from).to eq(2010)
      expect(new_project.month_from).to eq(10)
      expect(new_project.title).to eq('test title')
      expect(new_project.technology).to eq('test technology')
      expect(new_project.role).to eq('test role')
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      project = projects(:duckduckgo)
      updated_attributes = { description: 'changed' }
      process :update, method: :put, params: update_params(project.id, updated_attributes,
                                                           bob.id, 'projects')

      project.reload
      expect(project.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      project = projects(:duckduckgo)
      process :destroy, method: :delete, params: { person_id: bob.id,
                                                   id: project.id }

      expect(Project.exists?(project.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end

  def create_params(object, user_id, model_type)
    { data: { attributes: object, relationships: {
      person: {
        data: { type: 'People', id: user_id }
      } }, type: model_type } }
  end

  def update_params(object_id, updated_attributes, user_id, model_type)
    { data: { id: object_id, attributes: updated_attributes, relationships: {
        person: { data: { type: 'people', id: user_id } }
    }, type: model_type }, id: object_id }
  end
end
