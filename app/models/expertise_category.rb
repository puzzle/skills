# frozen_string_literal: true

#
# == Schema Information
#
# Table name: expertise_categories
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  discipline :integer          not null
#

class ExpertiseCategory < ApplicationRecord
  has_many :expertise_topics, dependent: :destroy

  enum discipline: [:development, :system_engineering]

  validates :discipline, presence: true
  validates :name, presence: true,
                   uniqueness: { scope: :discipline },
                   length: { maximum: 100 }

  scope :list, lambda { |discipline = nil|
    where(discipline: discipline)
  }
end
