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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

class AdvancedTrainingSerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :year_to, :month_to, :year_from, :month_from

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
