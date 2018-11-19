class PersonUpdatedAtSerializer < ApplicationSerializer
  type :people

  attributes :id, :updated_by, :updated_at
end
