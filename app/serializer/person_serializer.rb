class PersonSerializer < ApplicationSerializer
  type :people

  belongs_to :company, serializer: CompanyInPersonSerializer

  attributes :id, :birthdate, :language, :picture_path, :location,
             :martial_status, :updated_by, :name, :nationality,
             :nationality2, :role, :title, :competences, :updated_at

  def picture_path
    "/api/people/#{object.id}/picture?#{Time.zone.now}"
  end

  has_many :advanced_trainings do |serializer|
    serializer.object.advanced_trainings.list
  end

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
