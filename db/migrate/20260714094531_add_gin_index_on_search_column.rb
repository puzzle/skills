class AddGinIndexOnSearchColumn < ActiveRecord::Migration[8.1]
  def change
    add_index :people,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_people_on_search_column"

    add_index :departments,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_departments_on_search_column"

    add_index :roles,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_roles_on_search_column"

    add_index :projects,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_projects_on_search_column"

    add_index :activities,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_activities_on_search_column"

    add_index :educations,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_educations_on_search_column"

    add_index :advanced_trainings,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_advanced_trainings_on_search_column"

    add_index :contributions,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_contributions_on_search_column"

    add_index :skills,
              :search_column,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "gin_index_skills_on_search_column"
  end
end
