# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  radar       :integer
#  portfolio   :integer
#  default_set :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint(8)
#

class Skill < ApplicationRecord
  has_many :people_skills, dependent: :destroy
  has_many :people, through: :people_skills
  belongs_to :category
  has_one :parent_category, through: :category, source: :parent

  enum :radar, Settings.radar
  enum :portfolio, Settings.portfolio

  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :category_id }

  scope :list, -> { order(:title) }

  scope :default_set, -> { where(default_set: true) }

  def to_s
    title
  end
end
