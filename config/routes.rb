Rails.application.routes.draw do
  devise_for :people

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get root to: 'people#index'
  scope 'status' do
    get 'health', to: 'status#health'
    get 'readiness', to: 'status#readiness'
  end

  resources :people
  resources :skills

  # namespace :session do
  #   post '', action: :create
  #   post 'local', to: 'local#create'
  #   get 'local', to: 'local#new'

  #   get 'new'
  #   get 'destroy'
  #   get 'show_update_password'
  #   post 'update_password'

  #   if AuthConfig.oidc_enabled?
  #     get 'oidc', to: 'oidc#create'
  #   end
  # end

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
