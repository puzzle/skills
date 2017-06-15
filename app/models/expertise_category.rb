# encoding: utf-8
#
# == Schema Information
#
# Table name: expertise_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  discipline :integer
#

class ExpertiseCategory < ApplicationRecord
  has_many :expertise_topics, dependent: :destroy

  enum discipline: [:development, :system_engineering]

  validates :discipline, presence: true
  validates :name, presence: true, 
                   uniqueness: { scope: :discipline }, 
                   length: { maximum: 100 }

  scope :list, -> (discipline = nil) do 
    where(discipline: discipline )
  end

end
