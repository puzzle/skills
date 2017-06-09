# encoding: utf-8

class ExpertiseCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :discipline

  has_many :expertise_topics do |serializer|
    serializer.object.expertise_topics.list
  end
end
