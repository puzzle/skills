class ExpertiseTopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_topic

  has_one :expertise_category

end
