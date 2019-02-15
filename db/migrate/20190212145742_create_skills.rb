class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.string :title
      t.integer :radar
      t.integer :portfolio
      t.boolean :default_set

      t.timestamps
    end

    create_table :people_skills do |t|
      t.belongs_to :person, index: true
      t.belongs_to :skill, index: true
    end
  end
end
