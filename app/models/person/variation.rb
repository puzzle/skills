
# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthdate        :datetime
#  language         :string
#  location         :string
#  martial_status   :string
#  updated_by       :string
#  name             :string
#  origin           :string
#  role             :string
#  title            :string
#  origin_person_id :integer
#  variation_name   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string
#  picture          :string
#  competences      :string
#


class Person::Variation < Person
  belongs_to :origin_person, class_name: 'Person', foreign_key: :origin_person_id, inverse_of: false
  # belongs_to :status # Needed because STI don't work as expected.
  # the preceeding line was commented out after the RoR 5.2.1 update
  # since now belongs_to relations are always required (also when testing)

  validates :variation_name, uniqueness: { scope: :origin_person_id }
  validates :variation_name, presence: true

  default_scope { all.order(:variation_name) }
  scope :list, -> { all.order(:name) }

  # rubocop:disable Metrics/MethodLength
  def self.create_variation(variation_name, person_id)
    ActiveRecord::Base.transaction do
      person = Person.find(person_id)
      associations = [:activities, :projects, :advanced_trainings, :educations]

      person_variation = person.dup.becomes!(Person::Variation)
      person_variation.picture = person.picture
      person_variation.origin_person_id = person_id
      person_variation.variation_name = variation_name
      person_variation.save!
      person_variation.clone_associations(associations, person)
      person_variation
    end
  end
  # rubocop:enable Metrics/MethodLength

  def clone_associations(assoc_names, person)
    assoc_names.each do |assoc_name|
      assocs = person.send(assoc_name)
      assocs.each do |assoc|
        assoc_duplicate = assoc.dup
        assoc_duplicate.person_id = id
        assoc_duplicate.save!
      end
    end
  end
end
