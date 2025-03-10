class CertificatesController < CrudController
  self.permitted_attrs = %i[name points_value description
                            provider exam_duration type_of_exam
                            study_time notes]
  before_action :render_unauthorized_not_conf_admin

  def create(**options, &)
    super(:location => certificates_path,
          status: :unprocessable_entity)
  end
end
