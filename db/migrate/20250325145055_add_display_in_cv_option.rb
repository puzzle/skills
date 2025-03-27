class AddDisplayInCvOption < ActiveRecord::Migration[8.0]
  def change
    tables = [:activities, :advanced_trainings, :educations, :projects, :people]
    tables.each do |table|
      add_column table, :display_in_cv, :boolean, default: true, null: true
    end
  end
end
