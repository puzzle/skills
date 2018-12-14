class CreateLanguageSkills < ActiveRecord::Migration[5.2]
  def up
    create_table :language_skills do |t|
      t.string :language
      t.string :level
      t.string :certificate
      t.references :person, foreign_key: true

      t.timestamps
    end

    # TODO Migrate people to have standart languages

    remove_column :people, :language
  end

  def down
    drop_table :language_skills

    add_column :people, :language, :string

    Person.find_each do |p|
      p.language = 'Deutsch, Französisch, Englisch'
    end
  end
end
