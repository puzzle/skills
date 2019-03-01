class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :title
      t.references :parent, index: true, foreign_key: { to_table: :categories }

      t.timestamps
    end

    add_reference :skills, :category, index: true
  end
end
