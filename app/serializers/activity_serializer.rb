# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#  finish_at   :date
#  start_at    :date
#

class ActivitySerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :role, :finish_at, :start_at

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
