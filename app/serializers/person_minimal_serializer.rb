# frozen_string_literal: true

class PersonMinimalSerializer < ApplicationSerializer
  type :people

  attributes :id, :name, :title
end
