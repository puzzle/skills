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
#

class Skill < ApplicationRecord
  has_and_belongs_to_many :people

  enum radar: %i[adopt trial assess hold]
  enum portfolio: %i[aktiv passiv abbauen]

  validates :title, presence: true
  validates :title, length: { maximum: 100 }

end
