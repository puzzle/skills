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
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#  marital_status          :integer          default("single"), not null
#  email                   :string
#  department_id           :integer
#

class Person < ApplicationRecord
  include PgSearch::Model

  belongs_to :department

  mount_uploader :picture, PictureUploader
  has_many :projects, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :advanced_trainings, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :expertise_topic_skill_values, dependent: :destroy
  has_many :expertise_topics, through: :expertise_topic_skill_values
  has_many :language_skills, dependent: :delete_all
  has_many :person_roles, dependent: :destroy
  has_many :people_skills, dependent: :destroy
  has_many :skills, through: :people_skills
  has_many :roles, through: :person_roles

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

  SEARCHABLE_FIELDS = %w{name title competence_notes description
                         role technology location}.freeze

  # Returns either the attribute which contains the search term or nil
  #
  # It is neccessary to preload the person and its associations
  #
  # Because pg_search is case insensitive, we must search our attributes case-insensitive as well.
  # Therefore, the search_term gets downcased
  def found_in(search_term)
    search_term = search_term.downcase
    res = in_attributes(search_term, attributes)
    res = in_associations(search_term) if res.nil?
    res
  end

  private

  def in_associations(search_term)
    association_symbols.each do |sym|
      a = in_association(search_term, sym)
      if a
        return format('%<association>s#%<attribute_name>s',
                      association: sym.to_s, attribute_name: a)
      end
    end
    nil
  end

  def association_symbols
    keys = []
    Person.reflections.keys.each do |key|
      keys.push key.to_sym
    end
    keys
  end

  def in_association(search_term, sym)
    target = association(sym).target
    if target.is_a?(Array)
      return attribute_in_array(search_term, target)
    else
      return in_attributes(search_term, target.attributes)
    end
  end

  def attribute_in_array(search_term, array)
    array.each do |t|
      attribute = in_attributes(search_term, t.attributes)
      return attribute unless attribute.nil?
    end
    nil
  end

  def in_attributes(search_term, attrs)
    searchable_fields(attrs).each_pair do |key, value|
      return key if value.downcase.include?(search_term)
    end
    nil
  end

  def searchable_fields(fields)
    fields.keys.each do |key|
      fields.delete(key) unless SEARCHABLE_FIELDS.include?(key)
    end
    fields
  end

  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end
end
