class PersonSerializer < ApplicationSerializer
  attributes :id, :birthdate, :language, :picture_path, :location, :martial_status, :updated_by,
             :name, :origin, :role, :title, :status_id

  def picture_path
    "/api/people/#{object.id}/picture"
  end

  has_many :advanced_trainings do |serializer|
    serializer.object.advanced_trainings
  end

  has_many :activities do |serializer|
    serializer.object.activities
  end

  has_many :projects do |serializer|
    serializer.object.projects
  end

  has_many :educations do |serializer|
    serializer.object.educations
  end

  has_many :competences do |serializer|
    serializer.object.competences
  end
end
