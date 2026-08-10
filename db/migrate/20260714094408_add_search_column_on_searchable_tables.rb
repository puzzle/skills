class AddSearchColumnOnSearchableTables < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :search_column, :virtual, type: :text, as: "(coalesce(name, '') || ' ' || coalesce(title, '') || ' ' || coalesce(competence_notes, ''))", stored: true
    add_column :departments, :search_column, :virtual, type: :text, as: "(coalesce(name, ''))", stored: true
    add_column :roles, :search_column, :virtual, type: :text, as: "(coalesce(name, ''))", stored: true
    add_column :projects, :search_column, :virtual, type: :text, as: "(coalesce(description, '') || ' ' || coalesce(title, '') || ' ' || coalesce(technology, '') || ' ' || coalesce(role, ''))", stored: true
    add_column :activities, :search_column, :virtual, type: :text, as: "(coalesce(description, '') || ' ' || coalesce(role, ''))", stored: true
    add_column :educations, :search_column, :virtual, type: :text, as: "(coalesce(location, '') || ' ' || coalesce(title, ''))", stored: true
    add_column :advanced_trainings, :search_column, :virtual, type: :text, as: "(coalesce(description, ''))", stored: true
    add_column :contributions, :search_column, :virtual, type: :text, as: "(coalesce(title, ''))", stored: true
    add_column :skills, :search_column, :virtual, type: :text, as: "(coalesce(title, ''))", stored: true
  end
end
