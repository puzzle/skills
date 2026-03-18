require 'rails_helper'

RSpec.describe Api::CvsController, type: :controller do
  describe 'GET #index' do
    subject(:request_call) { get :index, params: params }

    let(:params) { { per_page: 15, page: 1 } }

    context 'when per_page param is missing' do
      let(:params) { {} }

      it 'redirects with default per_page' do
        request_call
        expect(response).to have_http_status(:redirect)
        expect(response.location).to include('per_page=15')
      end
    end

    context 'with valid params' do
      it 'returns http success' do
        request_call
        expect(response).to have_http_status(:ok)
      end

      it 'returns cvs wrapped in data' do
        request_call

        expect(json).to have_key('data')
        expect(json['data']).to be_an(Array)
      end

      it 'returns cvs with expected jsonapi structure' do
        request_call

        cv = json['data'].first

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

        attributes = json['data'].first['attributes']

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

        relationships = json['data'].first['relationships']

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
    end

    context 'with pagination' do
      let(:params) { { per_page: 4, page: 2 } }

      it 'returns the correct number of records' do
        request_call
        expect(json['data'].size).to eq(4)
      end

      it 'returns the correct page of records' do
        request_call

        returned_ids = json['data'].map { |cv| cv['id'].to_i }
        expected_ids = Person.limit(4).offset(4).pluck(:id)

        expect(returned_ids).to match_array(expected_ids)
      end
    end
  end
end