require 'rails_helper'

describe Person::EducationsController, type: :controller do
  before { auth(:ken) }

  describe 'GET index' do
    it 'returns all educations' do
      keys = %w(location title year_from year_to updated_by)
      process :index, method: :get, params: { type: 'Person', person_id: bob.id }

      educations = json['data']

      expect(educations.count).to eq(1)
      expect(educations.first['attributes'].count).to eq(5)
      json_object_includes_keys(educations.first['attributes'], keys)
    end
  end

  describe 'GET show' do
    it 'returns education' do
      education = educations(:bsc)

      process :show, method: :get, params: { type: 'Person', person_id: bob.id, id: education.id }

      education_attrs = json['data']['attributes']

      expect(education_attrs['title']).to eq(education.title)
    end
  end

  describe 'POST create' do
    it 'creates new education' do
      education = { title: 'test title',
                    location: 'Bern',
                    year_from: 2000,
                    year_to: 2015 }

      post :create, params: { type: 'Person', person_id: bob.id, education: education }

      new_education = Education.find_by(title: 'test title')
      expect(new_education).not_to eq(nil)
      expect(new_education.location).to eq('Bern')
      expect(new_education.year_from).to eq(2000)
      expect(new_education.year_to).to eq(2015)
    end
  end

  describe 'PUT update' do
    it 'updates existing person' do
      education = educations(:bsc)

      process :update, method: :put, params: { type: 'Person',
                                               id: education,
                                               person_id: bob.id,
                                               education: { title: 'changed' } }

      education.reload
      expect(education.title).to eq('changed')
    end
  end

  describe 'DELETE destroy' do
    it 'destroys existing person' do
      education = educations(:bsc)
      process :destroy, method: :delete, params: { type: 'Person',
                                                   person_id: bob.id,
                                                   id: education.id }

      expect(Education.exists?(education.id)).to eq(false)
    end
  end

  private

  def bob
    @bob ||= people(:bob)
  end
end
