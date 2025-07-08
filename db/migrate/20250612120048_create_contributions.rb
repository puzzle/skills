class CreateContributions < ActiveRecord::Migration[8.0]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :reference
      t.integer :person_id
      t.integer :year_from
      t.integer :year_to
      t.integer :month_from
      t.integer :month_to
      t.boolean :display_in_cv, default: true, null: false

      t.timestamps
    end
  end
end
