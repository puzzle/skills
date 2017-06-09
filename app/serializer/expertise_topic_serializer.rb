# encoding: utf-8

class ExpertiseTopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_topic

  has_many :expertise_topic_skill_values do |serializer|
    serializer.object.expertise_topic_skill_values.list
  end
end
