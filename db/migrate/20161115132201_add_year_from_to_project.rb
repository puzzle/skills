class AddYearFromToProject < ActiveRecord::Migration[5.0]
  def up
    return if ActiveRecord::Base.connection.column_exists?(:projects, :year_from)
    add_column :projects, :year_from, :integer
  end

  def down
    remove_column :projects, :year_from
  end
end
