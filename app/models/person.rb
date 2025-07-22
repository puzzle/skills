# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id                             :integer          not null, primary key
#  birthdate                      :datetime
#  location                       :string
#  updated_by                     :string
#  name                           :string
#  title                          :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  picture                        :string
#  competence_notes               :string
#  display_competence_notes_in_cv :boolean
#  company_id                     :bigint(8)
#  associations_updated_at        :datetime
#  nationality                    :string
#  nationality2                   :string
#  marital_status                 :integer          default("single"), not null
#  email                          :string
#  department_id                  :integer
#  shortname                      :string

class Person < ApplicationRecord
  include PgSearch::Model

  belongs_to :company
  belongs_to :department, optional: true

  mount_uploader :picture, PictureUploader
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :language_skills, dependent: :delete_all
  accepts_nested_attributes_for :language_skills, allow_destroy: true
  has_many :person_roles, dependent: :destroy
  accepts_nested_attributes_for :person_roles, allow_destroy: true
  has_many :people_skills, dependent: :destroy
  accepts_nested_attributes_for :people_skills
  has_many :skills, through: :people_skills
  has_many :roles, through: :person_roles

  accepts_nested_attributes_for :advanced_trainings, allow_destroy: true

  validates :display_competence_notes_in_cv, inclusion: [true, false]
  validates :location, :name, :nationality,
            :title, :email, presence: true
  validates :location, :name, :title,
            :email, :shortname, length: { maximum: 100 }

  validates :email,
            format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
                      message: 'Format nicht gültig' }

  validates :nationality,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) }
  validates :nationality2,
            inclusion: { in: ISO3166::Country.all.collect(&:alpha2) },
            allow_blank: true

  validate :picture_size

  scope :list, -> { order(:name) }

  scope :employed, lambda {
    where.not(company_id: Company.where(name: 'Ex-Mitarbeiter').select('id'))
  }

  scope :unemployed, -> { employed.invert_where }

  enum :marital_status, { single: 0, married: 1, widowed: 2, registered_partnership: 3,
                          divorced: 4 }

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
                    skills: [:title]
                  },
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def last_updated_at
    [associations_updated_at, updated_at].compact.max
  end

  def to_s
    name
  end

  private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes

    errors.add(:picture, :max_size_10MB)
  end
end
