class PersonMinimalSerializer < ApplicationSerializer
  type :people

  attributes :id, :name, :title
end
