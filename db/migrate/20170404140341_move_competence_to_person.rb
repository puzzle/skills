class MoveCompetenceToPerson < ActiveRecord::Migration[5.0]
  def up
    add_column :people, :competences, :string
    move_competences_to_person_attribute
    drop_table :competences
  end

  def down
    create_table :competences do |t|
      t.text :description
      t.timestamp :updated_at
      t.string :updated_by
      t.references :person
    end

    move_competences_back_to_own_table

    remove_column :people, :competences
  end

  private

  def move_competences_back_to_own_table
    Person.all.find_each do |person|
      Competence.create(description: person.competences.to_s,
                        person_id: person.id)
    end
  end

  def move_competences_to_person_attribute
    Person.all.find_each do |person|
      competences = ""
      person_competences = Competence.where(person_id: person.id)

      person_competences.find_each do |competence|
        if competence == person_competences.last
          competences << competence.description.to_s
        else
          competences << "#{competence.description} \n"
        end
      end
      person.update_column(:competences, competences)
    end
  end

  private

  class Competence < ActiveRecord::Base
  end
end
