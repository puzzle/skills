# encoding: utf-8
#
# == Schema Information
#
# Table name: expertise_topics
#
#  id                    :integer          not null, primary key
#  name                  :string
#  user_topic            :boolean          default(FALSE)
#  expertise_category_id :integer
#

class ExpertiseTopic < ApplicationRecord
  belongs_to :expertise_category
  has_many :expertise_topic_skill_values, dependent: :destroy

  validates :name, presence: true, 
                   length: { maximum: 100 }, 
                   uniqueness: { scope: :expertise_category }

  scope :list, -> { order(:name) }

end
