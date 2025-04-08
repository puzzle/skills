class AddDisplayInCvOption < ActiveRecord::Migration[8.0]
  def change
    tables = [:activities, :advanced_trainings, :educations, :projects]
    tables.each do |table|
      add_column table, :display_in_cv, :boolean, default: true, null: false
    end
    add_column :people, :display_competence_notes_in_cv, :boolean, default: true, null: false
  end
end
