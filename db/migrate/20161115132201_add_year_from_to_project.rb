class AddYearFromToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :year_from, :integer
  end
end
