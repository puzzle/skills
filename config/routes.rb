Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api' do
    resources :statuses
    resources :people, type: 'Person' do
      resources :advanced_trainings, controller: 'person/advanced_trainings'
      resources :activities, controller: 'person/activities'
      resources :projects, controller: 'person/projects'
      resources :educations, controller: 'person/educations'
      resources :competences, controller: 'person/competences'
      resources :person_variations, controller: 'person_variations', type: 'PersonVariation'
    end
  end
end
