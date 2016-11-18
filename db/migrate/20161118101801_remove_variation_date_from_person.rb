class RemoveVariationDateFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :variation_date
  end
end
