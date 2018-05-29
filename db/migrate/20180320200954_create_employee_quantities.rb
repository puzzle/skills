class CreateEmployeeQuantities < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_quantities do |t|
      t.string :category
      t.integer :quantity
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
