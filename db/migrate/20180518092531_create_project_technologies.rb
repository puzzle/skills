class CreateProjectTechnologies < ActiveRecord::Migration[5.1]
  def change
    create_table :project_technologies do |t|
      t.text :offer, array: true, default: []
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
