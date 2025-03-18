class CertificatesController < CrudController
  self.permitted_attrs = %i[designation title provider
                            points_value comment course_duration
                            exam_duration type_of_exam study_time]
  before_action :render_unauthorized_not_admin

  def create
    super(:location => certificates_path,
          status: :unprocessable_entity)
  end
end
