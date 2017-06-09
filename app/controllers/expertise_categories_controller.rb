# encoding: utf-8

class ExpertiseCategoriesController < CrudController
  self.permitted_attrs = [:name, :discipline]

  self.nested_models = [:expertise_topic]
end
