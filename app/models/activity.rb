# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Activity < ApplicationRecord
  belongs_to :person

  scope :list, -> { order(:year_from) }

end
