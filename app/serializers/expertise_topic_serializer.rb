# == Schema Information
#
# Table name: expertise_topics
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string           not null
#  user_topic            :boolean          default(FALSE)
#  expertise_category_id :bigint(8)        not null
#

class ExpertiseTopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_topic

  has_one :expertise_category

end
