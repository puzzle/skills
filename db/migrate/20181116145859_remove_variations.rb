class RemoveVariations < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :variation_name, :string
    remove_column :people, :origin_person_id, :integer
    remove_column :people, :type, :string
  end
end
