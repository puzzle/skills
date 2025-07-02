class FixTypoInAssociationsUpdatetAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :people, :associations_updatet_at, :associations_updated_at
  end
end
