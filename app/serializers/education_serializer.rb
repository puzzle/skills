# frozen_string_literal: true

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
#  year_from  :integer          not null
#  year_to    :integer
#  month_from :integer
#  month_to   :integer
#

class EducationSerializer < ApplicationSerializer
  attributes :id, :location, :title, :updated_by, :year_to, :month_to, :year_from, :month_from

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
