class PersonInCompanySerializer < ApplicationSerializer
  type :people

  attributes :id, :name, :title, :role
end
