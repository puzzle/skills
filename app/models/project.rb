# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  updated_by  :string
#  description :text
#  title       :text
#  role        :text
#  technology  :text
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Project < ApplicationRecord
  belongs_to :person

  scope :list, -> { order(:year_to) }
end
