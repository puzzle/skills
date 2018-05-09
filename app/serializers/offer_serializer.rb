class OfferSerializer < ApplicationSerializer
  attributes :id, :category, :offer
  belongs_to :company
end
