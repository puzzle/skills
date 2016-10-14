class InitialDbSetup < ActiveRecord::Migration[5.0]
  def change
    #Table statuses
    rename_table :status, :statuses

    #Table persons
    rename_table :person, :people
    rename_column :people, :image, :profile_picture
    rename_column :people, :martialstatus, :martial_status
    rename_column :people, :moddate, :updated_at
    add_column :people, :created_at, :timestamp
    rename_column :people, :moduser, :updated_by
    rename_column :people, :fk_status, :status_id
    rename_column :people, :rel_id, :variation_id

    #Table advanced_trainings
    rename_table :advancedtraining, :advanced_trainings
    rename_column :advanced_trainings, :moddate, :updated_at
    add_column :advanced_trainings, :created_at, :timestamp
    rename_column :advanced_trainings, :moduser, :updated_by
    rename_column :advanced_trainings, :yearfrom, :year_from
    rename_column :advanced_trainings, :yearto, :year_to
    rename_column :advanced_trainings, :fk_person, :person_id

    #Table activities
    rename_table :activity, :activities
    rename_column :activities, :moddate, :updated_at
    add_column :activities, :created_at, :timestamp
    rename_column :activities, :moduser, :updated_by
    rename_column :activities, :yearfrom, :year_from
    rename_column :activities, :yearto, :year_to
    rename_column :activities, :fk_person, :person_id
    
    #Table projects
    rename_table :project, :projects
    rename_column :projects, :moddate, :updated_at
    add_column :projects, :created_at, :timestamp
    rename_column :projects, :moduser, :updated_by
    rename_column :projects, :projectdescription, :description
    rename_column :projects, :projecttitle, :title
    rename_column :projects, :yearto, :year_to
    rename_column :projects, :fk_person, :person_id

    #Table educations
    rename_table :education, :educations
    rename_column :educations, :educationlocation, :location
    rename_column :educations, :educationtype, :type
    rename_column :educations, :moddate, :updated_at
    add_column :educations, :created_at, :timestamp
    rename_column :educations, :moduser, :updated_by
    rename_column :educations, :yearfrom, :year_from
    rename_column :educations, :yearto, :year_to
    rename_column :educations, :fk_person, :person_id
    
    #Table competences
    rename_table :competence, :competences
    rename_column :competences, :moddate, :updated_at
    add_column :competences, :created_at, :timestamp
    rename_column :competences, :moduser, :updated_by
    rename_column :competences, :fk_person, :person_id

  end
end
