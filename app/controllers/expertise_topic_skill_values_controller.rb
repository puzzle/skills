# encoding: utf-8

class ExpertiseTopicSkillValuesController < CrudController
  self.permitted_attrs = [:years_of_experience, :number_of_projects, :last_use, 
                          :skill_level, :comment, :expertise_topic_id, :person_id]
end
