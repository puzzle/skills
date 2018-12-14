# == Schema Information
#
# Table name: language_skills
#
#  id          :bigint(8)        not null, primary key
#  language    :string
#  level       :string
#  certificate :string
#  person_id   :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LanguageSkill < ApplicationRecord
  belongs_to :person, touch: true

  validates :language, :level, presence: true
  validates :language,
            inclusion: { in: LanguageList::COMMON_LANGUAGES.collect do |language|
              language.iso_639_1.upcase
            end }
  before_destroy :language_is_not_obligatory
  scope :list, -> {}

  private

  def language_is_not_obligatory
    return unless %w(DE EN FR).include?(language)
    errors.add(:language, 'darf nicht gelöscht werden')
    throw(:abort)
  end
end
