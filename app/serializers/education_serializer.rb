# == Schema Information
#
# Table name: educations
#
#  id         :integer          not null, primary key
#  location   :text
#  title      :text
#  updated_at :datetime
#  updated_by :string
#  person_id  :integer
#  finish_at  :date
#  start_at   :date
#

class EducationSerializer < ApplicationSerializer
  attributes :id, :location, :title, :updated_by, :finish_at, :start_at

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
