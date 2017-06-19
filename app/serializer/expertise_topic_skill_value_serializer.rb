# encoding: utf-8

class ExpertiseTopicSkillValueSerializer < ActiveModel::Serializer
  attributes :id, :years_of_experience, :number_of_projects, :last_use, :skill_level, :comment
  
  has_one :expertise_topic
  has_one :person
end
