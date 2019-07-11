class AddPositionToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :position, :integer
  end
end
