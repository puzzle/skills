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
  include Discard::Model

  has_many :people_skills, dependent: :destroy
  has_many :people, through: :people_skills
  belongs_to :category
  has_one :parent_category, through: :category, source: :parent

  enum :radar, Settings.radar
  enum :portfolio, Settings.portfolio

  validates :title, presence: true, length: { maximum: 100 }, uniqueness: { scope: :category_id }

  default_scope { kept }

  scope :list, -> { order(:title) }

  def self.for_select
    skills = list.includes(:category, :parent_category)
    title_counts = skills.map(&:title).tally

    skills.map { |skill| skill.format_for_select(title_counts) }
  end

  def format_for_select(title_counts)
    return [title, id] unless title_counts[title] > 1

    parent_title = parent_category&.title
    category_title = category.title

    ["#{title} (#{parent_title} - #{category_title})", id]
  end

  scope :default_set, -> { where(default_set: true) }

  def to_s
    title
  end
end
