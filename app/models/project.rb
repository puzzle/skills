# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  updated_by  :string
#  description :text
#  title       :text
#  role        :text
#  technology  :text
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Project < ApplicationRecord
  belongs_to :person
  validates :year_from, :year_to, :person_id, :role, :title, :technology, presence: true
  validates_length_of :description, maximum: 1000
  validates_length_of :technology, maximum: 100
  validate :year_from_before_year_to
  validates_length_of :role, :title, maximum: 30

  scope :list, -> { order(:year_to) }
end
