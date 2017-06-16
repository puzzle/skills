Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api' do
    scope '/auth' do
      post 'sign_in', to: 'authentication#sign_in'
    end

    resources :people do
      put 'picture', to: 'people#update_picture'
      get 'picture'
      get 'variations', to: 'person_variations#index'
      post 'variation', to: 'person_variations#create'
      get 'fws', to: 'people#export_fws'
    end

    resources :advanced_trainings, controller: 'advanced_trainings'
    resources :activities, controller: 'activities'
    resources :projects, controller: 'projects'
    resources :educations, controller: 'educations'
    resources :competences, controller: 'competences'

    # FWS
    resources :expertise_categories
    resources :expertise_topics
    resources :expertise_topic_skill_values


  end

  get '*path', to: 'static_assets#index'

end
