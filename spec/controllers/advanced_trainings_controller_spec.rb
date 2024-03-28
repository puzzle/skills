require 'rails_helper'

describe AdvancedTrainingsController do

  before(:each) do
    sign_in(auth_users(:admin))
  end

  let(:person) { people(:bob) }

  describe 'Crud with default behavior' do

    it 'index redirects to person itself' do
      get :index, params:{:person_id=> person}
      expect(response).to redirect_to(person_path(person))
    end

    it 'show redirects to person itself' do
      get :show, params:{:person_id=> person, id:person.advanced_trainings.first}
      expect(response).to redirect_to(person_path(person))
    end

    it 'Create action creates a new advanced training for person and renders parent person' do
      description = 'This is a description'
      month_from = 1
      year_from = 2020
      month_to = 1
      year_to = 2023
      post :create , params: {:person_id=> person, advanced_training: { month_from: month_from, year_from: year_from, month_to: month_to, year_to: year_to, description: description} }
      expect(response).to redirect_to(person_path(person))
      expect(person.advanced_trainings.last.description).to eq description
      expect(person.advanced_trainings.last.month_from).to eq month_from
      expect(person.advanced_trainings.last.year_from).to eq year_from
      expect(person.advanced_trainings.last.month_to).to eq month_to
    end

    it 'Update action changes an advanced training for person and renders parent person' do
      advanced_training_id = person.advanced_trainings.last.id
      month_from = 3
      year_from = 2020
      month_to = 1
      year_to = 2023
      description = 'This is an updated description'

      patch :update , params: {:person_id=> person.id, :id => advanced_training_id, advanced_training: { month_from: month_from, year_from: year_from, month_to: month_to, year_to: year_to, description: description} }
      expect(response).to redirect_to(person_path(person))
      expect(person.advanced_trainings.last.month_from).to eq month_from
      expect(person.advanced_trainings.last.year_from).to eq year_from
      expect(person.advanced_trainings.last.month_to).to eq month_to
      expect(person.advanced_trainings.last.year_to).to eq year_to
      expect(person.advanced_trainings.last.description).to eq description
    end

    it 'Delete action delete element ' do
      post :destroy , params:{:person_id=> person, id: person.advanced_trainings.first}
      expect(response).to redirect_to(person_path(person))
      expect(person.advanced_trainings).to eq []
    end
  end

  describe 'Replace missing values with nil for create and update' do

    it 'Create without end date' do
      description = 'This is a new description'
      month_from = 1
      year_from = 2020
      post :create , params: {:person_id=> person, advanced_training: { month_from: month_from, year_from: year_from, description: description} }
      expect(response).to redirect_to(person_path(person))
      expect(person.advanced_trainings.last.description).to eq description
      expect(person.advanced_trainings.last.month_from).to eq month_from
      expect(person.advanced_trainings.last.year_from).to eq year_from
      expect(person.advanced_trainings.last.month_to).to eq nil
      expect(person.advanced_trainings.last.year_to).to eq nil
    end

    it 'Update with end date' do
      advanced_training_id = person.advanced_trainings.last.id
      description = 'This is an updated description'

      month_from = 6
      year_from = 2000
      patch :update , params: {:person_id=> person.id, :id => advanced_training_id, advanced_training: {description: description, month_from: month_from, year_from: year_from} }
      expect(response).to redirect_to(person_path(person))
      expect(person.advanced_trainings.last.description).to eq description
      expect(person.advanced_trainings.last.month_from).to eq month_from
      expect(person.advanced_trainings.last.year_from).to eq year_from
      expect(person.advanced_trainings.last.month_to).to eq nil
      expect(person.advanced_trainings.last.year_to).to eq nil
    end
  end
end
