# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  parent_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  has_many :skills, dependent: :destroy
  belongs_to :parent, optional: true,
                      class_name: :Category,
                      inverse_of: :children

  has_many :children, foreign_key: :parent_id,
                      class_name: :Category,
                      dependent: :destroy,
                      inverse_of: :parent


  validates :title, presence: true
  validates :position, uniqueness: true
  validates :title, length: { maximum: 100 }

  scope :all_parents, -> { order(:position).where(parent_id: nil) }
  scope :all_children, -> { order(:position).where.not(parent_id: nil) }

  scope :list, -> { order(:position) }
end
