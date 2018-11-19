# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  language                :string
#  location                :string
#  martial_status          :string
#  updated_by              :string
#  name                    :string
#  role                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competences             :string
#  company_id              :bigint(8)
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#

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


  validates :birthdate, :language, :location, :name, :nationality,
            :role, :title, presence: true
  validates :location, :language, :martial_status, :name,
            :role, :title, length: { maximum: 100 }

  validates :nationality,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) }
  validates :nationality2,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) },
            allow_blank: true

  validate :picture_size

  scope :list, -> { order(:name) }

  pg_search_scope :search,
                  against: [
                    :language,
                    :location,
                    :name,
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

  private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end

end
