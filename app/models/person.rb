# == Schema Information
#
# Table name: people
#
#  id                       :integer          not null, primary key
#  birthdate                :datetime
#  language                 :string
#  location                 :string
#  martial_status           :string
#  updated_by               :string
#  name                     :string
#  origin                   :string
#  role                     :string
#  title                    :string
#  origin_person_id         :integer
#  variation_name           :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  type                     :string
#  picture                  :string
#  competences              :string
#  associations_updatet_at  :timestamp
#  company_id               :integer

class Person < ApplicationRecord
  include PgSearch

  belongs_to :company

  mount_uploader :picture, PictureUploader
  has_many :person_competences, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :expertise_topic_skill_values, dependent: :destroy
  has_many :expertise_topics, through: :expertise_topic_skill_values
  has_many :variations, foreign_key: :origin_person_id,
                        class_name: 'Person::Variation',
                        dependent: :destroy,
                        inverse_of: false

  before_destroy :destroy_variations

  validates :birthdate, :language, :location, :name, :origin,
            :role, :title, presence: true
  validates :location, :language, :martial_status, :name, :origin,
            :role, :title, :variation_name, length: { maximum: 100 }

  validate :valid_person
  validate :picture_size

  scope :list, -> { where(type: nil).order(:name) }

  pg_search_scope :search,
                  against: [
                    :language,
                    :location,
                    :name,
                    :origin,
                    :role,
                    :title,
                    :competences
                  ],
                  associated_against: {
                    projects: [:description, :title, :role, :technology],
                    activities: [:description, :role],
                    educations: [:location, :title],
                    advanced_trainings: :description,
                    expertise_topics: :name
                  },
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def destroy_variations
    unless is_a?(Person::Variation)
      variations.destroy_all
    end
  end

  private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end

  def valid_person
    return false unless is_a?(Person::Variation)
  end
end
