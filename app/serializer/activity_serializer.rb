# encoding: utf-8

class ActivitySerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :role, :year_from, :year_to
end
