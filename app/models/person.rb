# encoding: utf-8

# == Schema Information :updated_by,
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthdate        :datetime
#  picture          :binary           not null
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
  include PgSearch

  STATUSES = { 1 => 'Mitarbeiter',
               2 => 'Partner',
               3 => 'Bewerber',
               4 => 'Ex Mitarbeiter' }.freeze

  mount_uploader :picture, PictureUploader
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :variations, foreign_key: :origin_person_id,
                        class_name: Person::Variation

  before_destroy :destroy_variations

  validates :birthdate, :language, :location, :name, :origin,
            :role, :title, :status_id, presence: true
  validates :location, :martial_status, :name, :origin,
            :role, :title, :variation_name, length: { maximum: 50 }
  validates :language, length: { maximum: 100 }
  validate :valid_person
  validate :picture_size
  validate :valid_status

  scope :list, -> { where(type: nil).order(:name) }

  pg_search_scope :search,
                  against: [:language, :location, :name, :origin, :role, :title, :competences],
                  associated_against: {
                    projects: [:description, :title, :role, :technology],
                    activities: [:description, :role],
                    educations: [:location, :title],
                    advanced_trainings: :description
                  },
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def status
    STATUSES[status_id]
  end


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

  def valid_status
    return if STATUSES.include?(status_id)
    errors.add(:status_id, 'unbekannt')
  end

  def valid_person
    return false unless is_a?(Person::Variation)
  end
end
