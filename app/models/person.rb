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

class Person < ApplicationRecord
  include Export

  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :competences, dependent: :destroy
  has_many :variations, foreign_key: :origin_person_id, class_name: Person::Variation
  belongs_to :status
  validates :birthdate, :language, :location, :name, :origin, :role, :title, :status_id, presence: true
  validates_length_of :location, :martial_status, :updated_by, :name, :origin, :role, :title, :variation_name, maximum: 30
  validates_length_of :language, maximum: 100

  scope :list, -> { where(type: nil).order(:name) }
end
