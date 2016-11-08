# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  year_from   :integer
#  year_to     :integer
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdvancedTraining < ApplicationRecord
  belongs_to :person
end
