class MoveCompetenceToPerson < ActiveRecord::Migration
  def up
    add_column :people, :competences, :string
    move_competences_to_person_attr
    drop_table :competences
  end

  def down
    create_table :competences do |t|
      t.text :description
      t.timestamp :updated_at
      t.string :updated_by
      t.references :person
    end

    move_copmetences_back_to_own_class

    remove_column :people, :competences
  end

  private

  def move_copmetences_back_to_own_class
    Person.all.find_each do |person|
      Competence.create(description: person.competences.to_s,
                        person_id: person.id)
    end
  end

  def move_competences_to_person_attr
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
      person.update_attributes(competences: competences)
    end
  end

  class Competence < ActiveRecord::Base
  end
end
