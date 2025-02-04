class CreateLanguageSkills < ActiveRecord::Migration[5.2]
  def up
    create_table :language_skills do |t|
      t.string :language
      t.string :level
      t.string :certificate
      t.references :person, foreign_key: true

      t.timestamps
    end


    select_values("SELECT id FROM people").each do |person_id|
      LanguageSkill.create(language: 'EN', level: 'Keine', certificate: '', person_id: person_id)
      LanguageSkill.create(language: 'DE', level: 'Keine', certificate: '', person_id: person_id)
      LanguageSkill.create(language: 'FR', level: 'Keine', certificate: '', person_id: person_id)
    end

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
