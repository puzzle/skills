# encoding: utf-8

class ProjectSerializer < ApplicationSerializer
  attributes :id, :updated_by, :title, :description, :role, :technology, :year_from, :year_to
end
