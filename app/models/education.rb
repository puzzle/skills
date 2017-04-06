# encoding: utf-8

# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  title       :text
#  updated_at :datetime
#  updated_by :string
#  year_from  :integer
#  year_to    :integer
#  person_id  :integer
#

class Education < ApplicationRecord
  belongs_to :person
  validates :year_from, :year_to, :person_id, :title, :location, presence: true
  validates :location, :title, length: { maximum: 50 }
  validate :year_from_before_year_to

  scope :list, -> { order(:year_from) }
end
