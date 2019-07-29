# frozen_string_literal: true

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
#  year_from   :integer          not null
#  year_to     :integer
#  month_from  :integer
#  month_to    :integer
#

class ActivitySerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :role, :year_to, :month_from, :year_from, :month_to

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
