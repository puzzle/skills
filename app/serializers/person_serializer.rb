# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  birthdate               :datetime
#  language                :string
#  location                :string
#  martial_status          :string
#  updated_by              :string
#  name                    :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture                 :string
#  competences             :string
#  company_id              :bigint(8)
#  associations_updatet_at :datetime
#  nationality             :string
#  nationality2            :string
#

class PersonSerializer < ApplicationSerializer
  type :people

  belongs_to :company, serializer: CompanyInPersonSerializer

  attributes :id, :birthdate, :language, :picture_path, :location,
             :marital_status, :updated_by, :name, :nationality,
             :nationality2, :title, :competences, :updated_at

  def picture_path
    "/api/people/#{object.id}/picture?#{Time.zone.now}"
  end

  has_many :advanced_trainings do |serializer|
    serializer.object.advanced_trainings.list
  end

  has_many :roles

  has_many :activities do |serializer|
    serializer.object.activities.list
  end

  has_many :projects do |serializer|
    serializer.object.projects.list
  end

  has_many :educations do |serializer|
    serializer.object.educations.list
  end

  has_many :person_competences, include: :all

end
