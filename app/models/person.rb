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

  mount_uploader :picture, PictureUploader
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :competences, dependent: :destroy
  has_many :variations, foreign_key: :origin_person_id, class_name: Person::Variation
  belongs_to :status
  validates :birthdate, :language, :location, :name, :origin, :role, :title, :status_id, presence: true
  validates_length_of :location, :martial_status, :name, :origin, :role, :title, :variation_name, maximum: 50
  validates_length_of :language, maximum: 100
  validate :picture_size

  scope :list, -> { where(type: nil).order(:name) }
  default_scope { where(type: nil).order(:name) }

  pg_search_scope :search,
    against: [:language, :location, :name, :origin, :role, :title],
    associated_against: {
      projects: [:description, :title, :role, :technology],
      activities: [:description, :role],
      educations: [:location, :title],
      advanced_trainings: :description,
      competences: :description
    },
    using: { tsearch: { 
      prefix: true
    } }

  
  private

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end

end
