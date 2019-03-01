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

class SkillSerializer < ApplicationSerializer
  attributes :id, :title, :radar, :portfolio, :default_set, :category_id

  has_many :people, serializer: PeopleSerializer
  belongs_to :category
end
