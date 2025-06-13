# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  location                :string
#  updated_by              :string
#  name                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competence_notes        :string
#  company_id              :bigint(8)
#  associations_updated_at :datetime
#  nationality             :string
#  nationality2            :string
#  marital_status          :integer          default("single"), not null
#  email                   :string
#  department_id           :integer
#  shortname               :string
#

class PersonSerializer < ApplicationSerializer
  type :people

  belongs_to :company, serializer: CompanyInPersonSerializer
  belongs_to :department

  attributes :id, :birthdate, :picture_path, :location,
             :marital_status, :updated_by, :name, :nationality,
             :nationality2, :title, :competence_notes, :email,
             :shortname, :updated_at

  def picture_path
    "/api/people/#{object.id}/picture?#{Time.zone.now}"
  end

  has_many :advanced_trainings
  has_many :roles
  has_many :person_roles
  has_many :projects
  has_many :contributions

  has_many :activities do |serializer|
    serializer.object.activities.list
  end

  has_many :educations do |serializer|
    serializer.object.educations.list
  end

  has_many :language_skills do |serializer|
    serializer.object.language_skills.list
  end
end
