# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
  has_and_belongs_to_many :people, dependent: :restrict
  validates :name, length: { maximum: 100 }

  scope :list, -> { order(:name) }
end
