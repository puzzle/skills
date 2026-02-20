require 'rails_helper'

RSpec.describe Api::CvsController, type: :controller do
  describe 'GET #index' do
    let(:api_token) { 'test-token' }

    before do
      allow(ENV).to receive(:fetch).with('CVS_API_TOKEN', nil).and_return(api_token)

      request.headers['Authorization'] = "Token token=#{api_token}"
    end

    subject(:request_call) { get :index }

    it 'returns http success' do
      request_call
      expect(response).to have_http_status(:ok)
    end

    it 'returns cvs wrapped in data.data' do
      request_call

      expect(json).to have_key('data')
      expect(json['data']).to have_key('data')
      expect(json['data']['data']).to be_an(Array)
    end

    it 'returns cvs with expected jsonapi structure' do
      request_call

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
      request_call

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
      request_call

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
      request_call

      expect(json['data']['data'].size).to eq(Person.count)
    end
  end
end
