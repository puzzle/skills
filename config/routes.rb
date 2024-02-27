Rails.application.routes.draw do
  get root to: 'people#index'

  devise_for :people,
    skip: [:sessions],
    controllers:
      { omniauth_callbacks: 'omniauth_callbacks' }

    devise_scope :person do
      get 'sign_in', :to => 'devise/sessions#new', :as => :new_person_session
      post 'sign_in', to: 'devise/sessions#create', as: :person_session
      delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_person_session
    end

  resources :people
  resources :skills


  # Status
  scope 'status' do
    get 'health', to: 'status#health'
    get 'readiness', to: 'status#readiness'
  end

  # Outdated api routes
  namespace :api do
    resources :people do
      collection do
        get 'search', to: 'people/search#index'
      end

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
    resources :branch_adresses
    resources :categories, only: [:index, :show]
    resources :companies
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
end
