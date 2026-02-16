require 'rails_helper'

RSpec.describe Api::CvsController, type: :controller do
  describe 'GET #index' do
    subject(:request) { get :index }

    it 'returns http success' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'returns cvs wrapped in data.data' do
      request

      expect(json).to have_key('data')
      expect(json['data']).to have_key('data')
      expect(json['data']['data']).to be_an(Array)
    end

    it 'returns cvs with expected jsonapi structure' do
      request

      cv = json['data']['data'].first

      expect(cv).to include(
                      'id',
                      'type',
                      'attributes',
                      'relationships'
                    )

      expect(cv['type']).to eq('cv')
    end

    it 'includes main attributes on cv' do
      request

      attributes = json['data']['data'].first['attributes']

      expect(attributes).to include(
                              'name',
                              'title',
                              'email',
                              'birthdate',
                              'location',
                              'nationality',
                              'marital_status',
                              'competence_notes',
                              'picture_url',
                              'roles',
                              'skills',
                              'language_skills',
                              'projects',
                              'activities',
                              'educations',
                              'advanced_trainings',
                              'contributions'
                            )
    end

    it 'includes company and department relationships' do
      request

      relationships = json['data']['data'].first['relationships']

      expect(relationships).to include('company', 'department')

      expect(relationships['company']['data']).to include(
                                                    'id',
                                                    'type'
                                                  )

      expect(relationships['department']['data']).to include(
                                                       'id',
                                                       'type'
                                                     )
    end

    it 'returns all people as cvs' do
      request

      expect(json['data']['data'].size).to eq(Person.count)
    end
  end
end
