class AddNewAttributesToPeopleSkills < ActiveRecord::Migration[5.2]
  def change
    add_column :people_skills, :level, :integer
    add_column :people_skills, :interest, :integer
    add_column :people_skills, :certificate, :boolean, default: false
    add_column :people_skills, :core_competence, :boolean, default: false
  end
end
