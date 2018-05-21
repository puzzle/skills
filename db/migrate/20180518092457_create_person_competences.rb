class CreatePersonCompetences < ActiveRecord::Migration[5.1]
  def change
    create_table :person_competences do |t|
      t.string :category
      t.text :offer, array: true, default: []
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
