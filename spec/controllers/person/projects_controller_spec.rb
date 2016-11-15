require 'rails_helper'

describe Person::ProjectsController do
  describe 'GET index' do
    it 'returns all projects' do
      keys = %w(id technology title description role updated_by year_to)
      process :index, method: :get, params: { person_id: bob.id }

      projects = json['projects']

      expect(projects.count).to eq(1)
      expect(projects.first.count).to eq(8)
      json_object_includes_keys(projects.first, keys)
    end
  end

  describe 'GET show' do
    it 'returns project' do
      project = projects(:duckduckgo)

      process :show, method: :get, params: { person_id: bob.id, id: project.id }

      project_json = json['project']

      expect(project_json['technology']).to eq(project.technology)
      expect(project_json['title']).to eq(project.title)
      expect(project_json['description']).to eq(project.description)
      expect(project_json['role']).to eq(project.role)
    end
  end

  describe 'POST create' do
    it 'creates new project' do
      project = { description: 'test description',
                  updated_by: 'Bob',
                  year_to: 2015,
                  title: 'test title',
                  technology: 'test technology',
                  role: 'test role' }

      post :create, params: { person_id: bob.id, project: project }

      new_project = Project.find_by(description: 'test description')
      expect(new_project).not_to eq(nil)
      expect(new_project.year_to).to eq(2015)
      expect(new_project.title).to eq('test title')
      expect(new_project.technology).to eq('test technology')
      expect(new_project.role).to eq('test role')
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      project = projects(:duckduckgo)

      process :update, method: :put, params: { id: project,
                                               person_id: bob.id,
                                               project: { description: 'changed' } }

      project.reload
      expect(project.description).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      project = projects(:duckduckgo)
      process :destroy, method: :delete, params: { person_id: bob.id, id: project.id }

      expect(Project.exists?(project.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end
end
