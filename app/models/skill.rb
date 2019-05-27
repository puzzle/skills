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

  enum radar: Settings.radar
  enum portfolio: Settings.portfolio

  validates :title, presence: true
  validates :title, length: { maximum: 100 }
  
  validate :skill_uniqueness

  scope :list, -> { order(:title) }

  scope :default_set, -> { where(default_set: true) }

  private

  def skill_uniqueness
    same_named_skills = Skill.where(title: title)
    return if same_named_skills.empty?

    category_ids = same_named_skills.map(&:category).pluck(:id)
    return if category_ids.exclude?(category.id)

    errors.add(:base, 'Dieser Skill existiert bereits')
  end
end
