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
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  finish_at   :date
#  start_at    :date
#

class ProjectSerializer < ApplicationSerializer
  attributes :id, :updated_by, :title, :description, :role, :technology, :finish_at, :start_at

  belongs_to :person, serializer: PersonUpdatedAtSerializer

  has_many :project_technologies, include: :all
end
