class CreateProjectSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :project_skills do |t|
      t.belongs_to :project
      t.belongs_to :skill
      t.timestamps
    end
  end
end
