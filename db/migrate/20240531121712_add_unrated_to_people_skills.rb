class AddUnratedToPeopleSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :people_skills, :unrated, :boolean
  end
end
