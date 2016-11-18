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
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :competences, dependent: :destroy
  has_many :person_variations, foreign_key: :origin_person_id
  belongs_to :status

  scope :list, -> { order(:name) }


  def create_variation(variation_name)
    origin_clone = self.deep_clone include: [:activities,
                                       :projects, 
                                       :advanced_trainings,
                                       :educations, 
                                       :competences]

    origin_clone.type = 'PersonVariation'
    origin_clone.origin_person_id = self.id
    origin_clone.variation_name = variation_name
    origin_clone.save!
    variation = origin_clone.becomes(PersonVariation)
    variation.save!
  end

end
