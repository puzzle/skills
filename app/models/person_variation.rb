class PersonVariation < Person
  belongs_to :origin_person, class_name: 'Person', foreign_key: :origin_person_id
  
end
