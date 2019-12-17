# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  location                :string
#  updated_by              :string
#  name                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competence_notes        :string
#  company_id              :bigint(8)
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#  marital_status          :integer          default("single"), not null
#  email                   :string
#  department_id           :int
#

class Person < ApplicationRecord
  include PgSearch::Model

  belongs_to :company
  belongs_to :department

  mount_uploader :picture, PictureUploader
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :expertise_topic_skill_values, dependent: :destroy
  has_many :expertise_topics, through: :expertise_topic_skill_values
  has_many :language_skills, dependent: :delete_all
  has_many :people_roles, dependent: :destroy
  has_many :people_skills, dependent: :destroy
  has_many :skills, through: :people_skills
  has_many :roles, through: :people_roles

  validates :birthdate, :location, :name, :nationality,
            :title, :marital_status, presence: true
  validates :location, :name, :title,
            :email, length: { maximum: 100 }

  validates :nationality,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) }
  validates :nationality2,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) },
            allow_blank: true

  validate :picture_size

  scope :list, -> { order(:name) }

  enum marital_status: %i[single married widowed registered_partnership divorced]

  pg_search_scope :search,
                  against: [
                    :name,
                    :title,
                    :competence_notes
                  ],
                  associated_against: {
                    department: :name,
                    roles: :name,
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
