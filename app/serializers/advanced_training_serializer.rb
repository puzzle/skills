# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  finish_at   :date
#  start_at    :date
#

class AdvancedTrainingSerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :finish_at, :start_at

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
