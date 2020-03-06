Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  scope 'status' do
    get 'health', to: 'status#health'
    get 'readiness', to: 'status#readiness'
  end

  scope '/api' do


    resources :people do
      member do
        put 'picture', to: 'people/picture#update'
        get 'picture', to: 'people/picture#show'
      end
    end

    resources :skills do
      collection do
        get 'unrated_by_person'
      end
    end

    resources :advanced_trainings
    resources :activities
    resources :categories, only: [:index, :show]
    resources :departments, only: :index
    resources :educations
    resources :expertise_categories
    resources :expertise_topics
    resources :expertise_topic_skill_values
    resources :languages, only: :index
    resources :language_skills
    resources :people_skills
    resources :person_roles
    resources :person_role_levels, only: :index
    resources :projects
    resources :project_technologies
    resources :roles, only: :index

    if Rails.env.test?
      resource 'test_api', controller: 'test_api', only: [:create, :destroy]
    end

    get 'env_settings', to: 'env_settings#index'
  end

  get '*path', to: 'static_assets#index'

end
