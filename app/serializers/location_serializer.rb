class LocationSerializer < ApplicationSerializer
  attributes :id, :name
  has_one :company
end
