# == Schema Information
#
# Table name: expertise_topic_skill_values
#
#  id                  :bigint(8)        not null, primary key
#  years_of_experience :integer
#  number_of_projects  :integer
#  last_use            :integer
#  skill_level         :integer
#  comment             :string
#  person_id           :bigint(8)        not null
#  expertise_topic_id  :bigint(8)        not null
#

class ExpertiseTopicSkillValueSerializer < ActiveModel::Serializer
  attributes :id, :years_of_experience, :number_of_projects, :last_use, :skill_level, :comment

  has_one :expertise_topic
  has_one :person
end
