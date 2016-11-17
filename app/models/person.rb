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
  include Export

  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :competences, dependent: :destroy
  has_many :variations,
    ->(person) { where(origin_person_id: person.id) },
    class_name: 'Person',
    foreign_key: :origin_person_id

  belongs_to :origin_person, class_name: 'Person', foreign_key: :origin_person_id
  belongs_to :status

  scope :list, -> { order(:name) }

end
