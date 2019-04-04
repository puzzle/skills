class RenameCompetencesToCompetenceNotes < ActiveRecord::Migration[5.2]
  def change
    rename_column :people, :competences, :competence_notes
  end
end
