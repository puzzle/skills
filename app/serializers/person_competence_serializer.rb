# == Schema Information
#
# Table name: person_competences
#
#  id         :bigint(8)        not null, primary key
#  category   :string
#  offer      :text             default([]), is an Array
#  person_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PersonCompetenceSerializer < ApplicationSerializer
  attributes :id, :category, :offer
  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
