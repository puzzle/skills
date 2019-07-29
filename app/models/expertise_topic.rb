# frozen_string_literal: true

#
# == Schema Information
#
# Table name: expertise_topics
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string           not null
#  user_topic            :boolean          default(FALSE)
#  expertise_category_id :bigint(8)        not null
#

class ExpertiseTopic < ApplicationRecord
  belongs_to :expertise_category
  has_many :expertise_topic_skill_values, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 100 },
                   uniqueness: { scope: :expertise_category }

  scope :list, lambda { |category_id = nil|
    includes(:expertise_category, :expertise_topic_skill_values).
      where(expertise_categories: { id: category_id }).
      where(user_topic: false)
  }
end
