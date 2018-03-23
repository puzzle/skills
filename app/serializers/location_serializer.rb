class LocationSerializer < ApplicationSerializer
  attributes :id, :name
  belongs_to :company
end
