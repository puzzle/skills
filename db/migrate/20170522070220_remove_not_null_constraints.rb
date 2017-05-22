class RemoveNotNullConstraints < ActiveRecord::Migration[5.1]
  def change

    # Person
    change_column_null :people, :birthdate, true
    change_column_null :people, :language, true
    change_column_null :people, :location, true
    change_column_null :people, :martial_status, true
    change_column_null :people, :updated_by, true
    change_column_null :people, :name, true
    change_column_null :people, :origin, true
    change_column_null :people, :role, true
    change_column_null :people, :title, true
    change_column_null :people, :origin_person_id, true
    change_column_null :people, :variation_name, true

    # AdvancedTrainings
    change_column_null :advanced_trainings, :description, true
    change_column_null :advanced_trainings, :updated_by, true
    change_column_null :advanced_trainings, :year_from, true
    change_column_null :advanced_trainings, :year_to, true

    
    # Activities
    change_column_null :activities, :description, true
    change_column_null :activities, :updated_by, true
    change_column_null :activities, :role, true
    change_column_null :activities, :year_from, true
    change_column_null :activities, :year_to, true

    # Projects
    change_column_null :projects, :updated_by, true
    change_column_null :projects, :description, true
    change_column_null :projects, :title, true
    change_column_null :projects, :role, true
    change_column_null :projects, :technology, true
    change_column_null :projects, :year_from, true
    change_column_null :projects, :year_to, true

    # Educations
    change_column_null :educations, :location, true
    change_column_null :educations, :title, true
    change_column_null :educations, :updated_by, true
    change_column_null :educations, :year_from, true
    change_column_null :educations, :year_to, true

  end
end
