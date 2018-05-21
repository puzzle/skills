class PersonInCompanySerializer < ApplicationSerializer
  type :people

  attributes :id, :name, :title, :role, :origin_person_id
end
