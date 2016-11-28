class Person::Variation < Person
  belongs_to :origin_person, class_name: 'Person', foreign_key: :origin_person_id
  belongs_to :status # Needed because STI don't work as expected.

  scope :list, -> { all.order(:name) }

  def self.create_variation(variation_name, person_id)
    ActiveRecord::Base.transaction do
      person = Person.find(person_id)
      associations = [:activities, :projects, :advanced_trainings, :educations, :competences]

      person_variation = person.dup.becomes!(Person::Variation)
      person_variation.origin_person_id = person_id
      person_variation.variation_name = variation_name
      person_variation.save!
      person_variation.clone_associations(associations, person)
      person_variation
    end
  end

  def clone_associations(assoc_names, person)
    assoc_names.each do |assoc_name|
      assocs = person.send(assoc_name)
      assocs.each do |assoc|
        assoc_duplicate = assoc.dup
        assoc_duplicate.person_id = id
        assoc_duplicate.save!
      end
    end
  end
end
