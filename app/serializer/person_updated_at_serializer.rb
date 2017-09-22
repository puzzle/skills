# encoding: utf-8

class PersonUpdatedAtSerializer < ApplicationSerializer
  attributes :id, :updated_by, :updated_at
end
