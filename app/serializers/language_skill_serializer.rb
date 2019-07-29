# frozen_string_literal: true

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

class LanguageSkillSerializer < ApplicationSerializer
  attributes :id, :language, :level, :certificate

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
