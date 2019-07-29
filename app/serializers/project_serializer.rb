# frozen_string_literal: true

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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

class ProjectSerializer < ApplicationSerializer
  attributes :id, :updated_by, :title, :description, :role,
             :technology, :year_to, :month_to, :year_from, :month_from

  belongs_to :person, serializer: PersonUpdatedAtSerializer

  has_many :project_technologies, include: :all
end
