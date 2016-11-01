# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthdate        :datetime
#  profile_picture  :binary           not null
#  language         :string
#  location         :string
#  martial_status   :string
#  updated_by       :string
#  name             :string
#  origin           :string
#  role             :string
#  title            :string
#  status_id        :integer
#  origin_person_id :integer
#  variation_name   :string
#  variation_date   :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Person < ApplicationRecord
  has_many :projects, dependent: :delete_all
  has_many :activities, dependent: :delete_all
  has_many :advanced_trainings, dependent: :delete_all
  has_many :educations, dependent: :delete_all
  has_many :competences, dependent: :delete_all


  belongs_to :status

  scope :list, -> { order(:name) }
end
