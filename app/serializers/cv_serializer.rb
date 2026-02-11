class CvSerializer < ApplicationSerializer
  type :cv

  attributes :id,
             :name,
             :title,
             :email,
             :birthdate,
             :location,
             :nationality,
             :nationality2,
             :marital_status,
             :competence_notes,
             :picture_url

  belongs_to :company, serializer: CompanySerializer
  belongs_to :department, serializer: DepartmentSerializer

  attribute :roles
  attribute :skills
  attribute :language_skills
  attribute :projects
  attribute :activities
  attribute :educations
  attribute :advanced_trainings
  attribute :contributions

  private

  def anonymized?
    instance_options[:anon]
  end
end
