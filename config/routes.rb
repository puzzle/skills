Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/api' do

    resources 'languages', only: :index, controller: 'languages'

    resources :people do
      member do
        put 'picture', to: 'people/picture#update'
        get 'picture', to: 'people/picture#show'
      end
        get 'fws', to: 'people#export_fws'
    end

    resources :people_skills

    resources :employee_quantities, controller: 'employee_quantities'
    resources :locations, controller: 'locations'
    resources :offers, controller: 'offers'

    resources :categories, only: [:index, :show]
    resources :roles, only: :index
    resources :skills do
      collection do
        get 'unrated_by_person'
      end
    end

    resources :companies, controller: 'companies'

    resources :language_skills, controller: 'language_skills'
    resources :advanced_trainings, controller: 'advanced_trainings'
    resources :activities, controller: 'activities'
    resources :projects, controller: 'projects'
    resources :educations, controller: 'educations'
    resources :competences, controller: 'competences'
    resources :project_technologies, controller: 'project_technologies'
    resources :people_roles, controller: 'people_roles'

    # FWS
    resources :expertise_categories
    resources :expertise_topics
    resources :expertise_topic_skill_values

    if Rails.env.test?
      resource 'test_api', controller: 'test_api', only: [:create, :destroy]
    end

    get 'env_settings', to: 'env_settings#index'
  end

  get '*path', to: 'static_assets#index'

end
