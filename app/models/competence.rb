# == Schema Information
#
# Table name: competences
#
#  id          :integer          not null, primary key
#  description :text
#  updated_at  :datetime
#  updated_by  :string
#  person_id   :integer
#

class Competence < ApplicationRecord
  belongs_to :person

  scope :list, -> { order(:id) }
end
