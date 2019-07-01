# frozen_string_literal: true

class PeopleSerializer < ApplicationSerializer
  attributes :id, :name

  belongs_to :company, serializer: CompanyInPersonSerializer
end
