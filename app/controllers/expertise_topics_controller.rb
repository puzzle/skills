# encoding: utf-8

class ExpertiseTopicsController < CrudController
  self.permitted_attrs = [:name, :user_topic, :expertise_category_id]

  self.nested_models = [:expertise_topic_skill_values]
end
