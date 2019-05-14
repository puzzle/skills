class DropPersonCompetences < ActiveRecord::Migration[5.2]
  def change
    drop_table :person_competences
  end
end
