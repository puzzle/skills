# encoding: utf-8

class ActivitiesController < PersonRelationsController
  self.permitted_attrs = [:description, :role, :technology, :year_from, :year_to, :person_id]
end
