class CreateDepartmentSkillSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :department_skill_snapshots do |t|
      t.references :department, null: false, foreign_key: true
      t.text :skills

      t.timestamps
    end
  end
end
