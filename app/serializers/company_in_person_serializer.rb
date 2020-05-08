# frozen_string_literal: true

class CompanyInPersonSerializer < ApplicationSerializer
  type :companies

  attributes :id, :name
end
